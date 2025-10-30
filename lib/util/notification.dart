import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../routing.dart';
import 'navigation.dart';

const addExpenseActionId = 'add_expense';

const notificationTriggerPackageNames = [
  'com.josipkilic.promaja',
  'com.google.android.apps.wallet',
];

final addExpenseStreamController = StreamController<void>.broadcast(
  onListen: _drainPendingAddExpenseActions,
);

Stream<void> get addExpenseStream => addExpenseStreamController.stream;

int pendingAddExpenseActionCount = 0;

@pragma('vm:entry-point')
Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  await handleNotification(notificationResponse);
}

@pragma('vm:entry-point')
Future<void> onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
  WidgetsFlutterBinding.ensureInitialized();
  await handleNotification(
    notificationResponse,
    fromBackground: true,
  );
}

bool isNotificationFromProperPackageName({required String? packageName}) {
  // TODO: Remove this
  if (kDebugMode) {
    return packageName != 'com.josipkilic.trosko';
  }

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

String? getTransactionAmountFromNotification({
  required String? title,
  required String? content,
}) {
  final searchableText = '${title ?? ''} ${content ?? ''}';
  final match = RegExp(r'(\d+(?:[.,]\d+)+|\d+)').firstMatch(searchableText);

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

Future<bool> initializeNotificationPlugin(FlutterLocalNotificationsPlugin plugin) async {
  final initialized = await plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    ),
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
  );

  await getNotificationAppLaunchDetails(plugin);

  return initialized ?? false;
}

Future<void> handleNotification(
  NotificationResponse notificationResponse, {
  bool fromBackground = false,
}) async {
  if (notificationResponse.actionId != addExpenseActionId) {
    return;
  }

  if (fromBackground) {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  _enqueueAddExpenseAction();
}

Future<void> openAddExpenseFromNotification() async {
  final binding = WidgetsBinding.instance;

  for (var attempt = 0; attempt < 30; attempt++) {
    final navigatorContext = troskoNavigatorKey.currentContext;

    if (navigatorContext != null) {
      await binding.endOfFrame;

      openTransaction(
        navigatorContext,
        passedTransaction: null,
        categories: const [],
        passedCategory: null,
        onTransactionUpdated: () {},
      );
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}

void _enqueueAddExpenseAction() {
  if (addExpenseStreamController.isClosed) {
    return;
  }

  pendingAddExpenseActionCount++;
  _drainPendingAddExpenseActions();
}

Future<void> getNotificationAppLaunchDetails(
  FlutterLocalNotificationsPlugin plugin,
) async {
  final notificationAppLaunchDetails = await plugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.notificationResponse?.actionId == addExpenseActionId) {
    _enqueueAddExpenseAction();
  }
}

void _drainPendingAddExpenseActions() {
  if (!addExpenseStreamController.hasListener) {
    return;
  }

  while (pendingAddExpenseActionCount > 0) {
    addExpenseStreamController.add(null);
    pendingAddExpenseActionCount--;
  }
}
