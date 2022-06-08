import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:win_score/domain/sport_type.dart';
import 'package:win_score/resources/values/app_colors.dart';
import 'package:win_score/resources/values/app_strings.dart';
import 'package:win_score/ui/game_card.dart';

import '../domain/game_model.dart';

class SportDetailedScreen extends StatefulWidget {
  const SportDetailedScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = '/sportDetailed';

  @override
  State<SportDetailedScreen> createState() => _SportDetailedScreenState();
}

class _SportDetailedScreenState extends State<SportDetailedScreen> {
  late String gameId;
  late SportType sportType;
  late GameModel gameModel;
  late Future<List<MemberModel>> homeSquad;
  late Future<List<MemberModel>> awaySquad;

  String _selectedValue = "";

  Future<void> setSelectedValue(String newValue) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (_selectedValue == newValue) {
        _selectedValue = "";
        prefs.remove(gameId);
      } else {
        prefs.setString(gameId, newValue);
        _selectedValue = newValue;
      }
    });
  }

  Future<void> _loadOddValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print("saved value ${prefs.getString(gameId)}");
      if (prefs.getString(gameId) != null) {
        _selectedValue = prefs.getString(gameId)!;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadOddValue();
    });
  }

  Future<List<MemberModel>> fetchHomeSquad() async {
    final queryParametersHome = {
      'login': SPORT_LOGIN,
      'token': SPORT_TOKEN,
      'task': SPORT_TASK_SQUAD,
      'team': gameModel.homeTeam.teamId,
    };

    var urlHome =
        Uri.https(SPORT_BASE_URL, '/api/en/get.php', queryParametersHome);
    try {
      var response = await http.get(urlHome);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)["result"];
        var list =
            jsonResponse.map((member) => MemberModel.fromJson(member)).toList();
        return list;
      } else {
        throw const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: Text('Convert Error'),
          ),
        );
      }
    } catch (e) {
      throw const Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Convert Error'),
        ),
      );
    }
  }

  Future<List<MemberModel>> fetchAwaySquad() async {
    final queryParametersAway = {
      'login': SPORT_LOGIN,
      'token': SPORT_TOKEN,
      'task': SPORT_TASK_SQUAD,
      'team': gameModel.awayTeam.teamId,
    };

    var urlAway =
        Uri.https(SPORT_BASE_URL, '/api/en/get.php', queryParametersAway);
    try {
      var response = await http.get(urlAway);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)["results"];
        var list =
            jsonResponse.map((member) => MemberModel.fromJson(member)).toList();
        print(list);
        return list;
      } else {
        throw const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: Text('Convert Error'),
          ),
        );
      }
    } catch (e) {
      throw const Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Convert Error'),
        ),
      );
    }
  }

  Future<List<MemberModel>> fetchAwaySquad() async {
    final queryParametersAway = {
      'login': SPORT_LOGIN,
      'token': SPORT_TOKEN,
      'task': SPORT_TASK_SQUAD,
      'team': gameModel.awayTeam.teamId,
    };

    var urlAway =
        Uri.https(SPORT_BASE_URL, '/api/en/get.php', queryParametersAway);
    try {
      var response = await http.get(urlAway);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)["results"];
        var list =
            jsonResponse.map((member) => MemberModel.fromJson(member)).toList();
        print(list);
        return list;
      } else {
        throw const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: Text('Convert Error'),
          ),
        );
      }
    } catch (e) {
      throw const Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Convert Error'),
        ),
      );
    }
  }

  Future<void> _loadTeams() async {
    setState(() {
      homeSquad = fetchHomeSquad();
      awaySquad = fetchAwaySquad();
    });
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    gameId = args["gameId"] as String;
    sportType = args["type"] as SportType;
    gameModel = args["model"] as GameModel;

    _loadTeams();

    return Scaffold(
      backgroundColor: MAIN_BACKGROUND_COLOR,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          sportType.sportTypeName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              color: MAIN_LIGHT_BLACK_COLOR,
              child: GameCard(
                gameModel: gameModel,
                sportType: sportType,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: FutureBuilder<List<MemberModel>>(
                        future: homeSquad,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<MemberModel> data = snapshot.requireData;
                            return Container(
                                child: SizedBox(
                              height: 164,
                              width: 146,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PlayerName(
                                      playerName: data[index].memberName,
                                      align: TextAlign.start,
                                    );
                                  }),
                            ));
                          } else {
                            return const Text("No information about team");
                          }
                          return Center(
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  child: const CircularProgressIndicator()));
                        },
                      ),
                    ),
                    Container(
                      height: 164,
                      width: 1,
                      color: DIVIDER_COLOR,
                    ),
                    Expanded(
                      flex: 1,
                      child: FutureBuilder<List<MemberModel>>(
                        future: awaySquad,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<MemberModel> data = snapshot.requireData;
                            return Container(
                                child: SizedBox(
                              height: 164,
                              width: 146,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PlayerName(
                                      playerName: data[index].memberName,
                                      align: TextAlign.end,
                                    );
                                  }),
                            ));
                          } else {
                            return const Text("No information about team");
                          }
                          return Center(
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  child: const CircularProgressIndicator()));
                        },
                      ),
                    ),
                  ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RateButton(
                      selectedValue: _selectedValue,
                      child: Builder(builder: (BuildContext innerContext) {
                        return RateButtonState(
                          resultValue: '3.14',
                          selectedValue:
                              RateButton.of(innerContext).selectedValue,
                          onValueTapped: (value) {
                            setSelectedValue(value);
                          },
                        );
                      })),
                  RateButton(
                      selectedValue: _selectedValue,
                      child: Builder(builder: (BuildContext innerContext) {
                        return RateButtonState(
                          resultValue: '-',
                          selectedValue:
                              RateButton.of(innerContext).selectedValue,
                          onValueTapped: (value) {
                            setSelectedValue(value);
                          },
                        );
                      })),
                  RateButton(
                      selectedValue: _selectedValue,
                      child: Builder(builder: (BuildContext innerContext) {
                        return RateButtonState(
                          resultValue: '2.16',
                          selectedValue:
                              RateButton.of(innerContext).selectedValue,
                          onValueTapped: (value) {
                            setSelectedValue(value);
                          },
                        );
                      })),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RateButton extends InheritedWidget {
  final String selectedValue;

  const RateButton({
    Key? key,
    required this.selectedValue,
    required Widget child,
  }) : super(key: key, child: child);

  static RateButton of(BuildContext context) {
    final RateButton? result =
        context.dependOnInheritedWidgetOfExactType<RateButton>();
    assert(result != null, 'No value found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RateButton oldWidget) =>
      selectedValue != oldWidget.selectedValue;
}

class RateButtonState extends StatelessWidget {
  String resultValue;
  String selectedValue;
  bool isDouble = true;

  final Function(String) onValueTapped;

  RateButtonState({
    Key? key,
    required this.resultValue,
    required this.selectedValue,
    required this.onValueTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color buttonColor = valueButtonColor;
    Color textColor = MAIN_WHITE_COLOR;

    try {
      double.parse(resultValue);
      if (resultValue == selectedValue) {
        buttonColor = myMainYellowColor;
        textColor = MAIN_BLACK_COLOR;
      } else {
        buttonColor = valueButtonColor;
      }
      isDouble = true;
    } catch (e) {
      isDouble = false;
      textColor = NOT_DOUBLE_COLOR;
      buttonColor = valueNotButtonColor;
    }

    return SizedBox(
      height: 50,
      width: 90,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(buttonColor)),
          onPressed: () {
            if (isDouble) {
              onValueTapped.call(resultValue);
            }
          },
          child: (Text(
            resultValue.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ))),
    );
  }
}

class PlayerName extends StatelessWidget {
  final String playerName;
  final TextAlign align;

  const PlayerName({Key? key, required this.playerName, required this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        playerName,
        textAlign: align,
        style: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 14, color: NAMES_COLOR),
      ),
    );
  }
}
