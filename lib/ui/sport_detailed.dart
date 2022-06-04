import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:win_score/domain/GameModel.dart';
import 'package:win_score/domain/SportType.dart';
import 'package:win_score/resources/values/app_colors.dart';
import 'package:win_score/ui/game_card.dart';

class SportDetailedScreen extends StatefulWidget {
  String gameId;
  SportType sportType = SportType.FOOTBALL;

  SportDetailedScreen({Key? key, required this.sportType, required this.gameId})
      : super(key: key);

  static const routeName = '/sportDetailed';

  @override
  State<SportDetailedScreen> createState() =>
      _SportDetailedScreenState(gameId: gameId, sportType: sportType);
}

class _SportDetailedScreenState extends State<SportDetailedScreen> {
  String gameId;
  SportType sportType = SportType.FOOTBALL;
  late Future<GameModel> gameModel;

  String _selectedValue = "";

  _SportDetailedScreenState({required this.gameId, required this.sportType});

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
      print(
          "change value in store gameId $gameId ${_selectedValue} ${prefs.getString(gameId)}");

      // print("value $newValue selected $_selectedValue");
    });
  }

  Future<void> _loadValue() async {
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
    // final args =
    // ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // _sportType = args["type"] as SportType;
    // _gameId = (args["model"] as GameModel).gameId;
    setState(() {
      gameModel = fetchData();
      _loadValue();
    });
  }

  Future<GameModel> fetchData() async {
    try {
      String response =
          await rootBundle.loadString('assets/game_response.json');
      return GameModel.fromJson(jsonDecode(response));
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
    return Scaffold(
      backgroundColor: MAIN_BACKGROUND_COLOR,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          sportType.sportTypeName,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: FutureBuilder<GameModel>(
          future: gameModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              GameModel _gameModel = snapshot.requireData;
              return Column(
                children: [
                  Container(
                    color: MAIN_LIGHT_BLACK_COLOR,
                    child: GameCard(gameModel: _gameModel),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: SizedBox(
                              height: 164,
                              width: 146,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      _gameModel.homeTeam.teamLineup.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PlayerName(
                                      playerName:
                                          _gameModel.homeTeam.teamLineup[index],
                                      align: TextAlign.start,
                                    );
                                  }),
                            ),
                          ),
                          Container(
                            height: 164,
                            width: 1,
                            color: DIVIDER_COLOR,
                          ),
                          SizedBox(
                            height: 164,
                            width: 146,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    _gameModel.awayTeam.teamLineup.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return PlayerName(
                                    playerName:
                                        _gameModel.awayTeam.teamLineup[index],
                                    align: TextAlign.end,
                                  );
                                }),
                          ),
                        ]),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RateButton(
                            selectedValue: _selectedValue,
                            child:
                                Builder(builder: (BuildContext innerContext) {
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
                            child:
                                Builder(builder: (BuildContext innerContext) {
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
                            child:
                                Builder(builder: (BuildContext innerContext) {
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
              );
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
