import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../screens/transaction/transaction_screen.dart';
import 'navigation.dart';
import 'notification.dart';

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

    await backgroundNotificationsPlugin?.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
    );
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
      title: event.title,
      content: event.content,
    );

    /// Initialize `notifications` if not already done
    await initializeBackgroundLocalNotifications();

    /// Show `notification`
    await backgroundNotificationsPlugin?.show(
      0,
      // TODO: Localize
      transactionAmount != null ? 'Seems you spent €$transactionAmount' : event.packageName,
      transactionAmount != null ? 'You can add that expense in Troško' : 'This is just a test, ignore it',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'trosko_channel_id',
          'trosko_channel_name',
          category: AndroidNotificationCategory.service,
          actions: [
            AndroidNotificationAction(
              'add_expense',
              // TODO: Localize
              'Add expense',
            ),
          ],
        ),
      ),
    );
  }

  /// Called when the notification button is pressed
  @override
  Future<void> onNotificationButtonPressed(String id) async {
    // TODO: Show screen properly, check implementation in Wapx
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => troskoNavigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => TransactionScreen(
            passedTransaction: null,
            categories: const [],
            passedCategory: null,
            onTransactionUpdated: () {},
            key: const ValueKey(null),
          ),
        ),
      ),
    );
  }

  /// Called based on the `eventAction` set in [ForegroundTaskOptions]
  @override
  void onRepeatEvent(DateTime timestamp) {}
}
