import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:win_score/domain/GameModel.dart';
import 'package:win_score/domain/SportType.dart';
import 'package:win_score/resources/values/app_colors.dart';
import 'package:win_score/ui/game_card.dart';
import 'package:win_score/ui/sport_detailed.dart';

class SportListScreen extends StatefulWidget {
  const SportListScreen({Key? key}) : super(key: key);

  static const routeName = '/sportList';

  @override
  State<SportListScreen> createState() => _SportListScreenState();
}

class _SportListScreenState extends State<SportListScreen> {
  late Future<List<GameModel>> _gamesList;
  late SportType _sportType;

  @override
  void initState() {
    super.initState();

    setState(() {
      _gamesList = fetchData();
    });
  }

  Future<List<GameModel>> fetchData() async {
    try {
      String response = await rootBundle.loadString('assets/games_list.json');
      List<dynamic> result = json.decode(response);
      return result.map((data) => GameModel.fromJson(data)).toList();
    } catch (e) {
      throw const Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Convert Error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO  fix later
    final args =
        'sdfasdf'; //ModalRoute.of(context)!.settings.arguments as SportType;
    _sportType = SportType.FOOTBALL;
    return Scaffold(
      backgroundColor: MAIN_BACKGROUND_COLOR,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'args.sportTypeName',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    return InkWell(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SportDetailedScreen(
                                    gameId: data[index].gameId,
                                    sportType: _sportType,
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
                        child: GameCard(gameModel: data[index]),
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
