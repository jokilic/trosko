import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import 'notification_functions.dart';
import 'notification_helpers.dart';

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) => openTransactionFromNotification();

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  WidgetsFlutterBinding.ensureInitialized();
  openTransactionFromNotification();
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
  FlutterLocalNotificationsPlugin? backgroundNotificationsPlugin;

  ///
  /// INIT
  ///

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await notificationSubscription?.cancel();
    notificationSubscription = NotificationListenerService.notificationsStream.listen(
      handleNotification,
    );
  }

  ///
  /// DISPOSE
  ///

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await notificationSubscription?.cancel();
    notificationSubscription = null;
  }

  ///
  /// METHODS
  ///

  /// Initializes [FlutterLocalNotificationsPlugin] if not already initialized
  Future<void> initializeBackgroundLocalNotifications() async {
    if (backgroundNotificationsPlugin != null) {
      return;
    }

    backgroundNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await initializeNotificationPlugin(backgroundNotificationsPlugin!);
  }

  /// Shows `Troško` notification
  Future<void> handleNotification(ServiceNotificationEvent event) async {
    /// Run logic only if notification is shown
    if (event.hasRemoved ?? false) {
      return;
    }

    /// Run logic only if notification from proper app
    final shouldShowTroskoNotification = isNotificationFromProperPackageName(
      packageName: event.packageName,
    );

    /// Don't show notification if not necessary
    if (!shouldShowTroskoNotification) {
      return;
    }

    /// Try to get `transactionAmount` from the notification
    final transactionAmount = getTransactionAmountFromNotification(
      content: event.content,
    );

    /// Initialize `notifications` if not already done
    await initializeBackgroundLocalNotifications();

    /// Show `notification`
    await backgroundNotificationsPlugin?.show(
      0,
      transactionAmount != null
          ? 'expenseNotificationTitle'.tr(
              args: [
                transactionAmount,
                event.title ?? '',
              ],
            )
          : event.packageName,
      transactionAmount != null ? 'expenseNotificationText'.tr() : 'This is just a test.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'trosko_channel_id',
          'trosko_channel_name',
          category: AndroidNotificationCategory.service,
          actions: [
            AndroidNotificationAction(
              addExpenseActionId,
              'expenseNotificationButton'.tr(),
              showsUserInterface: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Called based on the `eventAction` set in [ForegroundTaskOptions]
  @override
  void onRepeatEvent(DateTime timestamp) {}
}
