import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(NotificationHandler());
}

void initForegroundTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'trosko_channel_id',
      channelName: 'Troško notifications',
      channelDescription: 'Notifications shown by the Troško app',
      channelImportance: NotificationChannelImportance.MAX,
      priority: NotificationPriority.MAX,
    ),
    iosNotificationOptions: const IOSNotificationOptions(),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.once(),
      autoRunOnBoot: true,
      allowWifiLock: true,
    ),
  );
}

Future<ServiceRequestResult> startForegroundTask() async {
  final isServiceRunning = await FlutterForegroundTask.isRunningService;

  if (isServiceRunning) {
    return FlutterForegroundTask.restartService();
  } else {
    return FlutterForegroundTask.startService(
      serviceId: 1,
      notificationTitle: 'Troško is running',
      notificationText: 'Tap to return to the app',
      notificationIcon: const NotificationIcon(
        metaDataName: 'app_icon',
      ),
      callback: startCallback,
    );
  }
}

Future<ServiceRequestResult> stopForegroundTask() => FlutterForegroundTask.stopService();

class NotificationHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    NotificationListenerService.notificationsStream.listen(
      (event) {
        print('Current notification: $event');
      },
    );
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    print('onRepeatEvent -> $timestamp');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await FlutterForegroundTask.clearAllData();
  }
}
