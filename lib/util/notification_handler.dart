import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

String? sanitizeNotificationString(String? value, {int maxLength = 120}) {
  final trimmed = value?.trim();

  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }

  if (trimmed.length > maxLength) {
    return '${trimmed.substring(0, maxLength - 3)}...';
  }

  return trimmed;
}

String getNotificationSignature(ServiceNotificationEvent event) => '${event.id}-${event.packageName}-${event.title}-${event.content}-${event.hasRemoved}';

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
      channelImportance: NotificationChannelImportance.DEFAULT,
      priority: NotificationPriority.DEFAULT,
      onlyAlertOnce: true,
    ),
    iosNotificationOptions: const IOSNotificationOptions(),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.nothing(),
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

Future<bool> isForegroundTaskRunning() => FlutterForegroundTask.isRunningService;

class NotificationHandler extends TaskHandler {
  StreamSubscription<ServiceNotificationEvent>? notificationsSubscription;
  String? lastNotificationSignature;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    notificationsSubscription = NotificationListenerService.notificationsStream.listen(
      handleNotification,
      onError: (error, stackTrace) => debugPrint('Troško notification listener error: $error'),
    );
  }

  Future<void> handleNotification(ServiceNotificationEvent event) async {
    if (event.hasRemoved ?? false) {
      return;
    }

    final signature = getNotificationSignature(event);
    if (signature == lastNotificationSignature) {
      return;
    }

    lastNotificationSignature = signature;

    final resolvedTitle = sanitizeNotificationString(event.title) ?? sanitizeNotificationString(event.packageName);
    final resolvedContent = sanitizeNotificationString(event.content) ?? sanitizeNotificationString(event.title) ?? sanitizeNotificationString(event.packageName);

    if (resolvedTitle == null && resolvedContent == null) {
      return;
    }

    final result = await FlutterForegroundTask.updateService(
      notificationTitle: resolvedTitle != null ? 'Troško: $resolvedTitle' : 'Troško notification',
      notificationText: resolvedContent ?? 'New notification received',
    );

    if (result is ServiceRequestFailure) {
      debugPrint('Troško notification update failed: ${result.error}');
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await notificationsSubscription?.cancel();

    notificationsSubscription = null;
    lastNotificationSignature = null;

    await FlutterForegroundTask.clearAllData();
  }
}
