import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../services/logger_service.dart';
import '../services/notification_service.dart';
import 'dependencies.dart';

void showNotificationFunction({
  required String title,
  required String body,
}) {
  /// Get [NotificationService] instance and show `notification`
  registerIfNotInitialized<NotificationService>(
    () => NotificationService(
      logger: LoggerService(),
    ),
    afterRegister: (controller) => controller.showNotification(
      title: title,
      body: body,
    ),
  );
}

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
  showNotificationFunction(
    title: 'Foreground notification',
    body: 'Payload -> ${notificationResponse.payload} - ActionId -> ${notificationResponse.actionId}',
  );
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  showNotificationFunction(
    title: 'Background notification',
    body: 'Payload -> ${notificationResponse.payload} - ActionId -> ${notificationResponse.actionId}',
  );
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(NotificationHandler());
}

class NotificationHandler extends TaskHandler {
  /// Called when the task is started
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  /// Called based on the `eventAction` set in [ForegroundTaskOptions]
  @override
  void onRepeatEvent(DateTime timestamp) {}

  /// Called when the task is destroyed
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  /// Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    // TODO: Perhaps send data from the listener here and handle showing notification
  }

  /// Called when the notification button is pressed
  @override
  void onNotificationButtonPressed(String id) {
    // TODO: Perhaps try to open proper screen here
  }

  /// Called when the notification itself is pressed
  @override
  void onNotificationPressed() {
    // TODO: Perhaps try to open proper screen here
  }

  /// Called when the notification itself is dismissed
  @override
  void onNotificationDismissed() {}
}
