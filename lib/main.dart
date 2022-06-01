import 'package:flutter/material.dart';
import 'package:win_score/resources/values/SelectionType.dart';
import 'package:win_score/resources/values/SportType.dart';
import 'package:win_score/resources/values/app_colors.dart';
import 'package:win_score/resources/values/app_strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CHOOSE_SPORT_TITLE,
      theme: ThemeData(
        primarySwatch: myMainThemeColor,
      ),
      home: const MyHomePage(title: CHOOSE_SPORT_TITLE),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SportType _sportType = SportType.FOOTBALL;

  void _increment(SelectionType arrowType) {
    setState(() {
      if (arrowType == SelectionType.PREVIOUS) {
        switch (_sportType) {
          case SportType.FOOTBALL:
            _sportType = SportType.HOCKEY;
            break;
          case SportType.BASKETBALL:
            _sportType = SportType.FOOTBALL;
            break;
          case SportType.HOCKEY:
            _sportType = SportType.BASKETBALL;
            break;
        }
      } else {
        switch (_sportType) {
          case SportType.FOOTBALL:
            _sportType = SportType.BASKETBALL;
            break;
          case SportType.BASKETBALL:
            _sportType = SportType.HOCKEY;
            break;
          case SportType.HOCKEY:
            _sportType = SportType.FOOTBALL;
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAIN_BACKGROUND_COLOR,
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _SelectionWidget(
                      arrowType: SelectionType.PREVIOUS,
                      onArrowTapped: (arrowType) {
                        _increment(arrowType);
                      }),
                  Container(
                    color: MAIN_BLACK_COLOR,
                    padding: EdgeInsets.all(34),
                    height: 120,
                    width: 120,
                    child: Image(image: AssetImage(_sportType.sportTypeIcon)),
                  ),
                  _SelectionWidget(
                    arrowType: SelectionType.NEXT,
                    onArrowTapped: (arrowType) {
                      _increment(arrowType);
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 55, left: 36, right: 36),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(myMainYellowColor),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 60))),
                  onPressed: () {
                    print('pressed');
                  },
                  child: Row(
                    children: const [
                      (Text(
                        COMFIRM_SPORT,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MAIN_WHITE_COLOR,
                        ),
                      )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionWidget extends StatelessWidget {
  final Function(SelectionType) onArrowTapped;
  final SelectionType arrowType;

  const _SelectionWidget({
    Key? key,
    required this.arrowType,
    required this.onArrowTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(28),
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            onArrowTapped.call(arrowType);
          }, // Image tapped
          splashColor: Colors.white10, // Splash color over image
          child: Center(
            child: Ink.image(
                fit: BoxFit.cover, // Fixes border issues
                width: 51,
                height: 51,
                image: AssetImage(
                  arrowType.arrowTypeIcon,
                )),
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }
}
