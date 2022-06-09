import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:win_score/domain/selection_type.dart';
import 'package:win_score/domain/sport_type.dart';
import 'package:win_score/resources/values/app_colors.dart';
import 'package:win_score/resources/values/app_strings.dart';
import 'package:win_score/ui/sport_list.dart';

class SportSelectScreen extends StatefulWidget {
  const SportSelectScreen({Key? key}) : super(key: key);

  @override
  State<SportSelectScreen> createState() => _SportSelectScreenState();
}

class _SportSelectScreenState extends State<SportSelectScreen> {
  SportType _sportType = SportType.FOOTBALL;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    initializeLocalNotificationsPlugin(initializationSettings);
  }

  void initializeLocalNotificationsPlugin(
      InitializationSettings initializationSettings) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  @override
  Future selectNotification(String? payload) {
    throw UnimplementedError();
  }

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
        title: const Center(
            child: Text(
          CHOOSE_SPORT_TITLE,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 80),
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
                    padding: const EdgeInsets.all(34),
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
                    Navigator.pushNamed(context, SportListScreen.routeName,
                        arguments: _sportType);
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
      padding: const EdgeInsets.all(28),
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
  }
}
