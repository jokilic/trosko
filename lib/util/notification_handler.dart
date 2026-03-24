import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';

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

FlutterLocalNotificationsPlugin? backgroundNotificationsPlugin;

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
Future<void> onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  try {
    await initializeBeforeAppStart();

    await handlePressedNotification(
      payload: notificationResponse.payload,
    );
  } catch (e) {
    return;
  }
}

/// Triggered by the notification listener package for matching Android notifications
@pragma('vm:entry-point')
void onNotificationEvent(NotificationEvent event) {
  unawaited(
    handleNotificationEvent(event),
  );
}

/// Handles notification event
Future<void> handleNotificationEvent(NotificationEvent event) async {
  final shouldShowTroskoNotification = isNotificationFromProperPackageName(
    packageName: event.packageName,
  );

  if (!shouldShowTroskoNotification) {
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();

  /// Keep translations available inside the background callback isolate
  await initializeLocalization();

  final transactionAmount = getTransactionAmountFromNotification(
    content: event.text,
  )?.toStringAsFixed(2);

  if (transactionAmount == null) {
    return;
  }

  await initializeBackgroundLocalNotifications();

  final now = DateTime.now();
  final id = now.millisecondsSinceEpoch % 1000000000;
  final title = 'expenseNotificationTitle'.tr();
  final body = 'expenseNotificationText'.tr(
    args: [
      '<b>$transactionAmount</b>',
      '<b>${event.title}</b>',
    ],
  );
  final addExpenseAction = AndroidNotificationAction(
    'add_expense',
    'expenseNotificationButton'.tr(),
    showsUserInterface: true,
  );

  await backgroundNotificationsPlugin?.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
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

Future<bool> initializeNotificationPlugin(FlutterLocalNotificationsPlugin plugin) async {
  final initialized = await plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    ),
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
  );

  return initialized ?? false;
}

Future<void> initializeBackgroundLocalNotifications() async {
  if (backgroundNotificationsPlugin != null) {
    return;
  }

  backgroundNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await initializeNotificationPlugin(backgroundNotificationsPlugin!);
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
