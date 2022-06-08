// const String channel_id = "123";
//
// class NotificationServiceImpl extends NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   @override
//   void init(
//       Future Function(int p1, String? p2, String? p3, String? p4)?
//           onDidReceive) {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//
//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceive);
//
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS,
//             macOS: null);
//
//     initializeLocalNotificationsPlugin(initializationSettings);
//
//     // tz.initializeTimeZones();
//   }
//
//   void initializeLocalNotificationsPlugin(
//       InitializationSettings initializationSettings) async {
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//     handleApplicationWasLaunchedFromNotification("");
//   }
//
//   @override
//   Future selectNotification(String? payload) {
//     // TODO: implement selectNotification
//     throw UnimplementedError();
//   }
//
//   @override
//   void cancelAllNotifications() {
//     // TODO: implement cancelAllNotifications
//   }
//
//   @override
//   void cancelNotificationGame(GameModel gameModel) {
//     // TODO: implement cancelNotificationGame
//   }
//
//   @override
//   Future<List<PendingNotificationRequest>> getAllScheduledNotifications() {
//     // TODO: implement getAllScheduledNotifications
//     throw UnimplementedError();
//   }
//
//   @override
//   GameModel getGameFromPayload(String payload) {
//     // TODO: implement getGameFromPayload
//     throw UnimplementedError();
//   }
//
//   @override
//   void handleApplicationWasLaunchedFromNotification(String payload) {
//     // TODO: implement handleApplicationWasLaunchedFromNotification
//   }
//
//   @override
//   void showNotification(GameModel gameModel, String notificationMessage) async {
//     await flutterLocalNotificationsPlugin.show(
//         gameModel.hashCode,
//         "applicationName",
//         notificationMessage,
//         const NotificationDetails(
//             android: AndroidNotificationDetails(channel_id, "applicationName",
//                 channelDescription: 'To remind you about upcoming birthdays')),
//         payload: jsonEncode(gameModel));
//   }
//
//   @override
//   void scheduleNotificationGame(
//       GameModel gameModel, String notificationMessage) async {
//     DateTime now = DateTime.now();
//     DateTime birthdayDate = DateTime.now(); //gameModel.startDate;
//     DateTime correctedBirthdayDate = birthdayDate;
//
//     if (birthdayDate.year < now.year) {
//       correctedBirthdayDate =
//           new DateTime(now.year, birthdayDate.month, birthdayDate.day);
//     }
//
//     Duration difference = now.isAfter(correctedBirthdayDate)
//         ? now.difference(correctedBirthdayDate)
//         : correctedBirthdayDate.difference(now);
//
//     bool didApplicationLaunchFromNotification =
//         await _wasApplicationLaunchedFromNotification();
//
//     if (!didApplicationLaunchFromNotification) {
//       showNotification(gameModel, notificationMessage);
//       return;
//     }
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         gameModel.hashCode,
//         "applicationName",
//         notificationMessage,
//         tz.TZDateTime.now(tz.local).add(difference),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(channel_id, "applicationName",
//                 channelDescription: 'To remind you about upcoming birthdays')),
//         payload: jsonEncode(gameModel),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);
//   }
//
//   Future<bool> _wasApplicationLaunchedFromNotification() async {
//     NotificationAppLaunchDetails? notificationAppLaunchDetails =
//         await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//
//     if (notificationAppLaunchDetails != null) {
//       return notificationAppLaunchDetails.didNotificationLaunchApp;
//     }
//
//     return false;
//   }
// }
