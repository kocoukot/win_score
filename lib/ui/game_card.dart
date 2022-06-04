import 'package:flutter/material.dart';
import 'package:win_score/domain/GameModel.dart';
import 'package:win_score/resources/values/app_colors.dart';

class GameCard extends StatelessWidget {
  final GameModel gameModel;

  const GameCard({Key? key, required this.gameModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
              child: Container(
            padding:
                const EdgeInsets.only(top: 22, left: 16, right: 16, bottom: 20),
            child: Text(
              gameModel.leagueName,
              style: const TextStyle(
                  color: MAIN_WHITE_COLOR,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TeamCard(teamModel: gameModel.homeTeam),
              Container(
                padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
                child: Column(
                  children: [
                    Text(
                      gameModel.startTime,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(gameModel.startDate,
                        style: const TextStyle(
                            color: TEAM_TEXT_COLOR,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              TeamCard(teamModel: gameModel.awayTeam)
            ],
          ),
          const Divider()
        ],
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final TeamModel teamModel;

  const TeamCard({super.key, required this.teamModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: const Image(
                image: AssetImage('assets/img_team_logo.png'),
                height: 69,
                width: 69,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                teamModel.teamName,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                    color: TEAM_TEXT_COLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const Image(
              image: AssetImage('assets/img_flag.png'),
              height: 26,
              width: 47,
            ),
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

    try {
      double.parse(resultValue);
      if (resultValue == selectedValue) {
        buttonColor = myMainYellowColor;
      } else {
        buttonColor = valueButtonColor;
      }
      isDouble = true;
    } catch (e) {
      isDouble = false;
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
              color: MAIN_WHITE_COLOR,
            ),
          ))),
    );
  }
}
