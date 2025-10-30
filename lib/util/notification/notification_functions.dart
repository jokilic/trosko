import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../routing.dart';
import '../../services/hive_service.dart';
import '../dependencies.dart';
import '../navigation.dart';
import 'notification_handler.dart';

const addExpenseActionId = 'add_expense';

final addExpenseStreamController = StreamController.broadcast(
  onListen: clearAddExpenseActions,
);

Stream get addExpenseStream => addExpenseStreamController.stream;

var addExpenseCount = 0;

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

Future<void> getNotificationAppLaunchDetails(
  FlutterLocalNotificationsPlugin plugin,
) async {
  final notificationAppLaunchDetails = await plugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.notificationResponse?.actionId == addExpenseActionId) {
    incrementAddExpenseAction();
  }
}

void incrementAddExpenseAction() {
  if (addExpenseStreamController.isClosed) {
    return;
  }

  addExpenseCount++;
  clearAddExpenseActions();
}

void clearAddExpenseActions() {
  if (!addExpenseStreamController.hasListener) {
    return;
  }

  while (addExpenseCount > 0) {
    addExpenseStreamController.add(null);
    addExpenseCount--;
  }
}

Future<void> openTransactionFromNotification() async {
  final binding = WidgetsBinding.instance;

  for (var attempt = 0; attempt < 30; attempt++) {
    final navigatorContext = troskoNavigatorKey.currentContext;

    if (navigatorContext != null) {
      await binding.endOfFrame;

      final categories = getIt.get<HiveService>().value.categories;

      openTransaction(
        navigatorContext,
        passedTransaction: null,
        categories: categories,
        passedCategory: null,
        onTransactionUpdated: SystemNavigator.pop,
      );

      return;
    }

    await Future.delayed(
      const Duration(milliseconds: 300),
    );
  }
}
