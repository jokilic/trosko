import 'dart:async';
import 'dart:developer';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../services/logger_service.dart';
import '../services/notification_service.dart';
import 'dependencies.dart';

const troskoNotificationPayloadTitleKey = 'title';
const troskoNotificationPayloadBodyKey = 'body';
const troskoNotificationPayloadShouldShowKey = 'shouldShow';

const defaultNotificationTitle = 'Notification from Promaja';
const defaultNotificationBody = '--';

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
  log('Foreground notification');

  showNotificationFunction(
    title: 'Foreground notification',
    body: 'Payload -> ${notificationResponse.payload} - ActionId -> ${notificationResponse.actionId}',
  );
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  log('Background notification');

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
  ///
  /// VARIABLES
  ///

  StreamSubscription<ServiceNotificationEvent>? notificationSubscription;
  final FlutterLocalNotificationsPlugin backgroundNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool notificationsInitialized = false;

  ///
  /// METHODS
  ///

  Future<void> ensureNotificationsInitialized() async {
    if (notificationsInitialized) {
      return;
    }

    await backgroundNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    notificationsInitialized = true;
  }

  Future<void> handleNotification(ServiceNotificationEvent event) async {
    if (event.packageName != promajaPackageName) {
      return;
    }

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

    await backgroundNotificationsPlugin.show(
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

  /// Called based on the `eventAction` set in [ForegroundTaskOptions]
  @override
  void onRepeatEvent(DateTime timestamp) {}

  /// Called when the task is destroyed
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await notificationSubscription?.cancel();
    notificationSubscription = null;
  }

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
