import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:win_score/domain/sport_type.dart';
import 'package:win_score/resources/values/app_colors.dart';

import '../domain/game_model.dart';

class GameCard extends StatelessWidget {
  final GameModel gameModel;
  final SportType sportType;

  const GameCard({Key? key, required this.gameModel, required this.sportType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Container(
          padding:
              const EdgeInsets.only(top: 22, left: 16, right: 16, bottom: 20),
          child: Text(
            gameModel.league.leagueName,
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
            Column(
              children: [
                Container(
                  color: Colors.blue,
                )
              ],
            ),
            TeamCard(teamModel: gameModel.homeTeam, sportType: sportType),
            Container(
              padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
              child: Column(
                children: [
                  Text(
                    gameModel.getGameTime(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(gameModel.getGameDate(),
                      style: const TextStyle(
                          color: TEAM_TEXT_COLOR,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            TeamCard(
              teamModel: gameModel.awayTeam,
              sportType: sportType,
            )
          ],
        ),
        const SizedBox(
          height: 36,
        )
      ],
    );
  }
}

class TeamCard extends StatelessWidget {
  final TeamModel teamModel;
  final SportType sportType;

  const TeamCard({super.key, required this.teamModel, required this.sportType});

  @override
  Widget build(BuildContext context) {
    late Widget flagWidget;
    final SvgParser parser = SvgParser();
    if (teamModel.teamCC.isEmpty) {
      flagWidget = Icon(Icons.error);
    } else {
      flagWidget = SvgPicture.network(
        width: 96,
        height: 52,
        "https://spoyer.ru/api/icons/countries/${teamModel.teamCC}.svg",
        fit: BoxFit.fill,
        semanticsLabel: 'A shark?!',
        placeholderBuilder: (BuildContext context) =>
            const CircularProgressIndicator(),
      );
    }

    return SizedBox(
      width: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              width: 70,
              height: 70,
              imageUrl:
                  "https://spoyer.ru/api/team_img/${sportType.sportApi}/${teamModel.teamId}.png",
              placeholder: (context, url) => Container(
                  padding: EdgeInsets.all(20),
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            // "https://spoyer.ru/api/team_img/${sportType.sportApi}/${teamModel.teamId}.png"
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
          Align(alignment: Alignment.bottomCenter, child: flagWidget

              // CachedNetworkImage(

              //   imageUrl:
              //   "https://spoyer.ru/api/icons/countries/${teamModel
              //       .teamCC}.svg",
              //   placeholder: (context, url) =>
              //       Container(
              //           padding: const EdgeInsets.symmetric(
              //               vertical: 5, horizontal: 15),
              //           height: 5,
              //           width: 5,
              //           child: const CircularProgressIndicator(
              //               strokeWidth: 2)),
              //   errorWidget: (context, url, error) => const Icon(Icons.error),
              // ),
              )
        ],
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
