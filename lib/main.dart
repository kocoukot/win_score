import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:win_score/resources/values/app_colors.dart';
import 'package:win_score/resources/values/app_strings.dart';
import 'package:win_score/service/notification/notification_service.dart';
import 'package:win_score/ui/sport_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // <----
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CHOOSE_SPORT_TITLE,
      routes: {
        // SportListScreen.routeName: (context) => const SportListScreen(),
        // SportDetailedScreen.routeName: (context) => const SportDetailedScreen()
      },
      theme: ThemeData(
        primarySwatch: myMainThemeColor,
      ),
      home: SportListScreen(),
    );
  }
}
