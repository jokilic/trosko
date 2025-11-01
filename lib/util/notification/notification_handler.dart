import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../../main.dart';
import '../../models/notification_payload/notification_payload.dart';
import '../currency.dart';
import '../localization.dart';
import 'notification_helpers.dart';

/// Triggered when the user taps the notification
@pragma('vm:entry-point')
Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  try {
    await handlePressedNotification(
      payload: notificationResponse.payload,
    );
  } catch (e) {
    return;
  }
}

/// Triggered when a notification is received while the app is terminated
@pragma('vm:entry-point')
Future<void> onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
  try {
    await initializeBeforeAppStart();

    await handlePressedNotification(
      payload: notificationResponse.payload,
    );
  } catch (e) {
    return;
  }
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

    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();

    /// Initialize [EasyLocalization]
    await initializeLocalization();

    /// Try to get `transactionAmount` from the notification
    final transactionAmount = getTransactionAmountFromNotification(
      content: event.content,
    );

    /// Don't show notification if `transactionAmount` doesn't exist
    if (transactionAmount == null) {
      return;
    }

    /// Initialize `notifications` if not already done
    await initializeBackgroundLocalNotifications();

    /// Generate `title` for the notification
    final title = 'expenseNotificationTitle'.tr(
      args: [
        transactionAmount.toStringAsFixed(2),
        event.title ?? '',
      ],
    );

    /// Generate `body` for the notification
    final body = 'expenseNotificationText'.tr();

    /// Generate `addExpense` for the notification
    final addExpenseAction = AndroidNotificationAction(
      'add_expense',
      'expenseNotificationButton'.tr(),
      showsUserInterface: true,
    );

    /// Get current [DateTime]
    final now = DateTime.now();

    /// Show `notification`
    await backgroundNotificationsPlugin?.show(
      now.millisecondsSinceEpoch,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'trosko_channel_id',
          'trosko_channel_name',
          category: AndroidNotificationCategory.service,
          actions: [addExpenseAction],
        ),
      ),
      payload: NotificationPayload(
        name: event.title,
        amountCents: formatCurrencyToCents(
          '$transactionAmount',
        ),
        createdAt: now,
      ).toJson(),
    );
  }

  /// Called based on the `eventAction` set in [ForegroundTaskOptions]
  @override
  void onRepeatEvent(DateTime timestamp) {}
}
