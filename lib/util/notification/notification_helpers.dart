import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../routing.dart';
import '../../services/hive_service.dart';
import '../currency.dart';
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
  try {
    final context = troskoNavigatorKey.currentState?.context;

    if (payload != null && context != null) {
      /// Navigate to base route
      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );

      /// Get `amountCents` from the value in notification `payload`
      final amountCents = formatCurrencyToCents(payload);

      log('amountCents -> $amountCents');

      /// Get `categories` from [Hive]
      final categories = getIt.get<HiveService>().value.categories;

      /// Navigate to [TransactionScreen]
      openTransaction(
        context,
        passedTransaction: null,
        categories: categories,
        passedCategory: null,
        passedAmountCents: amountCents,
        onTransactionUpdated: SystemNavigator.pop,
      );
    }
  } catch (e) {
    return;
  }
}

bool isNotificationFromProperPackageName({required String? packageName}) {
  return packageName != 'com.josipkilic.trosko';

  if (packageName?.isEmpty ?? true) {
    return false;
  }

  for (final name in notificationTriggerPackageNames) {
    if (packageName!.contains(name)) {
      return true;
    }
  }

  return false;
}

String? getTransactionAmountFromNotification({required String? content}) {
  if (content?.isEmpty ?? true) {
    return null;
  }

  final match = RegExp(r'(\d+(?:[.,]\d+)+|\d+)').firstMatch(content!);

  if (match == null) {
    return null;
  }

  final raw = match.group(0)!.trim().replaceAll(',', '.');

  final value = double.tryParse(raw);

  if (value == null) {
    return null;
  }

  return value.toStringAsFixed(2);
}
