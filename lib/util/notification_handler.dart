import 'dart:developer';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(NotificationHandler());
}

class NotificationHandler extends TaskHandler {
  /// Called when the task is started
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    log('[JOSIP] onStart(starter: ${starter.name})');
  }

  /// Called based on the `eventAction` set in [ForegroundTaskOptions]
  @override
  void onRepeatEvent(DateTime timestamp) {}

  /// Called when the task is destroyed
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    log('[JOSIP] onDestroy(isTimeout: $isTimeout)');
  }

  /// Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    log('[JOSIP] onReceiveData: $data');
  }

  /// Called when the notification button is pressed
  @override
  void onNotificationButtonPressed(String id) {
    log('[JOSIP] onNotificationButtonPressed: $id');
  }

  /// Called when the notification itself is pressed
  @override
  void onNotificationPressed() {
    log('[JOSIP] onNotificationPressed');
  }

  /// Called when the notification itself is dismissed
  @override
  void onNotificationDismissed() {
    log('[JOSIP] onNotificationDismissed');
  }
}
