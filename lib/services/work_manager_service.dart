import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import '../util/dependencies.dart';
import 'logger_service.dart';
import 'notification_service.dart';

class WorkManagerService {
  final LoggerService logger;
  final bool notificationsEnabled;

  WorkManagerService({
    required this.logger,
    required this.notificationsEnabled,
  });

  ///
  /// VARIABLES
  ///

  static const uniqueName = 'trosko_background_task';
  static const taskName = 'trosko_periodic_task';

  ///
  /// INIT
  ///

  Future<void> init() async {
    await initializeWorkManager();
    await toggleTask(
      notificationsEnabled: notificationsEnabled,
    );
  }

  ///
  /// METHODS
  ///

  /// Initializes [WorkManager]
  Future<void> initializeWorkManager() async => Workmanager().initialize(callbackDispatcher);

  /// Toggle task, depending on notifications being active
  Future<void> toggleTask({
    required bool notificationsEnabled,
  }) async {
    if (notificationsEnabled) {
      await startTask();
    } else {
      await stopTask();
    }
  }

  /// Registers [WorkManager] periodic task
  Future<void> startTask() async => Workmanager().registerPeriodicTask(
    uniqueName,
    taskName,
    frequency: const Duration(minutes: 30),
    constraints: Constraints(
      networkType: NetworkType.notRequired,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );

  /// Stops [WorkManager] tasks
  Future<void> stopTask() async => Workmanager().cancelAll();
}

@pragma('vm:entry-point')
void callbackDispatcher() => Workmanager().executeTask(
  (taskName, _) async {
    try {
      /// Initialize Flutter related tasks
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();

      /// Initialize only what's needed for background task
      await initializeForBackgroundTask();

      return Future.value(true);
    } catch (e) {
      /// Show failure notification
      await showBackgroundTaskNotification(
        title: 'callbackDispatcher() -> $taskName',
        body: '$e',
      );

      return Future.value(false);
    }
  },
);

/// Shows background task notification
Future<void> showBackgroundTaskNotification({
  required String title,
  required String body,
}) async {
  final notificationService = getIt.get<NotificationService>();

  final canShowNotification = notificationService.value.notificationGranted && notificationService.value.listenerGranted && notificationService.value.useNotificationListener;

  if (!canShowNotification) {
    return;
  }

  await notificationService.initializeLocalNotifications();

  final plugin = notificationService.flutterLocalNotificationsPlugin;

  await plugin?.show(
    0,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'trosko_background_task_channel_id',
        'Troško background task notifications',
        channelDescription: 'Background task notifications shown by the Troško app',
        category: AndroidNotificationCategory.service,
        importance: Importance.max,
        priority: Priority.max,
        ticker: 'ticker',
      ),
    ),
  );
}
