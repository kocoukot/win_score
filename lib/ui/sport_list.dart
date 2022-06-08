import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:win_score/domain/game_model.dart';
import 'package:win_score/domain/sport_type.dart';
import 'package:win_score/resources/values/app_colors.dart';
import 'package:win_score/ui/game_card.dart';
import 'package:win_score/ui/sport_detailed.dart';
import 'package:win_score/utils/date_util.dart';

import '../resources/values/app_strings.dart';

class SportListScreen extends StatefulWidget {
  const SportListScreen({Key? key}) : super(key: key);

  static const routeName = '/sportList';

  @override
  State<SportListScreen> createState() => _SportListScreenState();
}

class _SportListScreenState extends State<SportListScreen> {
  late Future<List<GameModel>> _gamesList;
  late SportType _sportType;

  Future<List<GameModel>> fetchDataTest() async {
    List<Uri> uriList = [];
    var currentDay = DateTime.now();
    var newDate = currentDay;

    for (int i = 0; i < 7; i++) {
      var date = requestDateFormat(newDate);
      final queryParameters = {
        'login': SPORT_LOGIN,
        'token': SPORT_TOKEN,
        'task': SPORT_TASK,
        'sport': _sportType.sportApi,
        'day': date,
      };
      var url = Uri.https(SPORT_BASE_URL, '/api/get.php', queryParameters);
      uriList.add(url);
      var t = i;
      newDate = newDate.add(const Duration(days: 1));
    }
    print(uriList);

    var responses = await Future.wait([
      http.get(uriList[0]),
      http.get(uriList[1]),
      http.get(uriList[2]),
      http.get(uriList[3]),
      http.get(uriList[4]),
      http.get(uriList[5]),
      http.get(uriList[6]),
    ]);

    var list = <GameModel>[
      ..._getGameModelFromResponse(responses[0]),
      ..._getGameModelFromResponse(responses[1]),
      ..._getGameModelFromResponse(responses[2]),
      ..._getGameModelFromResponse(responses[3]),
      ..._getGameModelFromResponse(responses[4]),
      ..._getGameModelFromResponse(responses[5]),
      ..._getGameModelFromResponse(responses[6]),
    ];
    list.sort((a, b) => a.startTime.compareTo(b.startTime));
    return list;
  }

  List<GameModel> _getGameModelFromResponse(http.Response response) {
    return [
      if (response.statusCode == 200)
        for (var i in json.decode(response.body)["games_pre"])
          GameModel.fromJson(i),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SportType;
    _sportType = args;
    setState(() {
      _gamesList = fetchDataTest();
    });
    return Scaffold(
      backgroundColor: MAIN_BACKGROUND_COLOR,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          args.sportTypeName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<GameModel>>(
          future: _gamesList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<GameModel> data = snapshot.requireData;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Color bgColor = Colors.black;
                    if ((index % 2) == 0) {
                      bgColor = MAIN_BACKGROUND_COLOR;
                    } else {
                      bgColor = MAIN_LIGHT_BLACK_COLOR;
                    }
                    return Container(
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SportDetailedScreen(
                                      gameId: data[index].gameId,
                                      sportType: args,
                                    )),
                          )
                          // Navigator.pushNamed(
                          //     context, SportDetailedScreen.routeName, arguments: {
                          //   "model": data[index],
                          //   "type": _sportType
                          // })
                        },
                        child: Container(
                          color: bgColor,
                          child: GameCard(
                            gameModel: data[index],
                            sportType: _sportType,
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
