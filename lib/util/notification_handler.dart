import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../main.dart';
import '../models/notification_payload/notification_payload.dart';
import '../routing.dart';
import '../services/hive_service.dart';
import 'currency.dart';
import 'dependencies.dart';
import 'localization.dart';
import 'navigation.dart';

const notificationTriggerPackageNames = [
  'com.revolut.revolut',
];

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

Future<bool> initializeNotificationPlugin(FlutterLocalNotificationsPlugin plugin) async {
  final initialized = await plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    ),
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
  );

  return initialized ?? false;
}

Future<void> handlePressedNotification({required String? payload}) async {
  if (payload?.isEmpty ?? true) {
    return;
  }

  try {
    final context = await getNavigatorContext();

    if (context == null) {
      return;
    }

    /// Navigate to base route
    Navigator.of(context).popUntil((route) => route.isFirst);

    /// Get instance of [Hive]
    final hive = getIt.get<HiveService>().value;

    /// Get `categories` from [Hive]
    final categories = hive.categories;

    /// Get `locations` from [Hive]
    final locations = hive.locations;

    /// Navigate to [TransactionScreen]
    openTransaction(
      context,
      passedTransaction: null,
      passedAITransaction: null,
      categories: categories,
      locations: locations,
      passedCategory: null,
      passedLocation: null,
      passedNotificationPayload: payload != null ? NotificationPayload.fromJson(payload) : null,
      onTransactionUpdated: SystemNavigator.pop,
    );
  } catch (e) {
    return;
  }
}

Future<BuildContext?> getNavigatorContext() async {
  for (var attempt = 0; attempt < 20; attempt++) {
    final navigatorState = troskoNavigatorKey.currentState;

    if (navigatorState != null) {
      await WidgetsBinding.instance.endOfFrame;
      return navigatorState.context;
    }

    await Future.delayed(
      const Duration(milliseconds: 150),
    );
  }

  return null;
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
    )?.toStringAsFixed(2);

    /// Don't show notification if `transactionAmount` doesn't exist
    if (transactionAmount == null) {
      return;
    }

    /// Initialize `notifications` if not already done
    await initializeBackgroundLocalNotifications();

    /// Get current [DateTime]
    final now = DateTime.now();

    /// Generate notification `id`
    final id = now.millisecondsSinceEpoch % 1000000000;

    /// Generate `title` for the notification
    final title = 'expenseNotificationTitle'.tr();

    /// Generate `body` for the notification
    final body = 'expenseNotificationText'.tr(
      args: [
        '<b>$transactionAmount</b>',
        '<b>${event.title}</b>',
      ],
    );

    /// Generate `addExpense` for the notification
    final addExpenseAction = AndroidNotificationAction(
      'add_expense',
      'expenseNotificationButton'.tr(),
      showsUserInterface: true,
    );

    /// Show `notification`
    await backgroundNotificationsPlugin?.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'trosko_notification_channel_id',
          'Troško notifications',
          channelDescription: 'Notifications shown by the Troško app',
          actions: [addExpenseAction],
          styleInformation: BigTextStyleInformation(
            body,
            contentTitle: title,
            htmlFormatBigText: true,
            htmlFormatContent: true,
          ),
          category: AndroidNotificationCategory.service,
          importance: Importance.max,
          priority: Priority.max,
          ticker: 'ticker',
        ),
      ),
      payload: NotificationPayload(
        name: event.title,
        amountCents: formatCurrencyToCents(
          transactionAmount,
        ),
        createdAt: now,
      ).toJson(),
    );
  }

  bool isNotificationFromProperPackageName({required String? packageName}) {
    if (packageName?.isEmpty ?? true) {
      return false;
    }

    return notificationTriggerPackageNames.any(packageName!.contains);
  }

  double? getTransactionAmountFromNotification({required String? content}) {
    if (content?.isEmpty ?? true) {
      return null;
    }

    final match = RegExp(r'(\d+(?:[.,]\d+)+|\d+)').firstMatch(content!);

    if (match == null) {
      return null;
    }

    final raw = match.group(0)!.trim().replaceAll(',', '.');

    return double.tryParse(raw);
  }

  /// Called based on the `eventAction` set in [ForegroundTaskOptions]
  @override
  void onRepeatEvent(DateTime timestamp) {}
}
