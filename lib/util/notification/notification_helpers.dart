import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/notification_payload/notification_payload.dart';
import '../../routing.dart';
import '../../services/hive_service.dart';
import '../dependencies.dart';
import '../navigation.dart';
import 'notification_handler.dart';

const notificationTriggerPackageNames = [
  'com.josipkilic.promaja',
  'com.revolut.revolut',
];

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

    /// Get `categories` from [Hive]
    final categories = getIt.get<HiveService>().value.categories;

    /// Navigate to [TransactionScreen]
    openTransaction(
      context,
      passedTransaction: null,
      categories: categories,
      passedCategory: null,
      passedNotificationPayload: payload != null ? NotificationPayload.fromJson(payload) : null,
      onTransactionUpdated: SystemNavigator.pop,
    );
  } catch (e) {
    return;
  }
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
