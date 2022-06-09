import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:win_score/resources/values/app_colors.dart';
import 'package:win_score/resources/values/app_strings.dart';
import 'package:win_score/service/work_manager.dart';
import 'package:win_score/ui/sport_detailed.dart';
import 'package:win_score/ui/sport_list.dart';
import 'package:win_score/ui/sport_select.dart';
import 'package:workmanager/workmanager.dart';

import 'service/notification/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  Workmanager().initialize(
    callbackDispatcher,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: CHOOSE_SPORT_TITLE,
      routes: {
        SportListScreen.routeName: (context) => const SportListScreen(),
        SportDetailedScreen.routeName: (context) => const SportDetailedScreen()
      },
      theme: ThemeData(
        primarySwatch: myMainThemeColor,
      ),
      home: const SportSelectScreen(),
    );
  }
}
