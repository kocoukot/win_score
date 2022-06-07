import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:win_score/domain/GameModel.dart';

abstract class NotificationService {
  void init(
      Future<dynamic> Function(int, String?, String?, String?)? onDidReceive);

  Future selectNotification(String? payload);

  void showNotification(GameModel gameModel, String notificationMessage);

  void scheduleNotificationGame(
      GameModel gameModel, String notificationMessage);

  void cancelNotificationGame(GameModel gameModel);

  void cancelAllNotifications();

  void handleApplicationWasLaunchedFromNotification(String payload);

  GameModel getGameFromPayload(String payload);

  Future<List<PendingNotificationRequest>> getAllScheduledNotifications();
}
