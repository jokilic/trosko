import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../services/notification_service.dart';

const troskoNotificationPayloadTitleKey = 'title';
const troskoNotificationPayloadBodyKey = 'body';
const troskoNotificationPayloadShouldShowKey = 'shouldShow';

const defaultNotificationTitle = 'Notification from Promaja';
const defaultNotificationBody = '--';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(NotificationHandler());
}

class NotificationHandler extends TaskHandler {
  ///
  /// VARIABLES
  ///

  StreamSubscription<ServiceNotificationEvent>? notificationSubscription;
  FlutterLocalNotificationsPlugin? backgroundNotificationsPlugin;
  bool notificationsInitialized = false;

  ///
  /// METHODS
  ///

  /// Initializes [FlutterLocalNotificationsPlugin] if not already initialized
  Future<void> ensureNotificationsInitialized() async {
    if (notificationsInitialized) {
      return;
    }

    backgroundNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await backgroundNotificationsPlugin?.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
    );

    notificationsInitialized = true;
  }

  /// Shows `Troško` notification
  Future<void> handleNotification(ServiceNotificationEvent event) async {
    /// Run logic only if notification from proper app
    if (event.packageName != promajaPackageName) {
      return;
    }

    /// Run logic only if notification is shown
    if (event.hasRemoved ?? false) {
      return;
    }

    final title = event.title?.trim() ?? defaultNotificationTitle;
    final body = event.content?.trim() ?? defaultNotificationBody;

    final isAppInForeground = await FlutterForegroundTask.isAppOnForeground;

    FlutterForegroundTask.sendDataToMain({
      troskoNotificationPayloadTitleKey: title,
      troskoNotificationPayloadBodyKey: body,
      troskoNotificationPayloadShouldShowKey: isAppInForeground,
    });

    if (isAppInForeground) {
      return;
    }

    await ensureNotificationsInitialized();

    final notificationId = event.id ?? DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);

    await backgroundNotificationsPlugin?.show(
      notificationId,
      'NotificationHandler -> handleNotification()',
      '$title -> $body',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'trosko_channel_id',
          'trosko_channel_name',
          category: AndroidNotificationCategory.service,
        ),
      ),
    );
  }

  /// Called when the task is started
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await notificationSubscription?.cancel();
    notificationSubscription = NotificationListenerService.notificationsStream.listen(
      handleNotification,
    );
  }

  /// Called when the task is destroyed
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await notificationSubscription?.cancel();
    notificationSubscription = null;
  }

  /// Called based on the `eventAction` set in [ForegroundTaskOptions]
  @override
  void onRepeatEvent(DateTime timestamp) {}

  /// Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {}

  /// Called when the notification button is pressed
  @override
  void onNotificationButtonPressed(String id) {}

  /// Called when the notification itself is pressed
  @override
  void onNotificationPressed() {}

  /// Called when the notification itself is dismissed
  @override
  void onNotificationDismissed() {}
}
