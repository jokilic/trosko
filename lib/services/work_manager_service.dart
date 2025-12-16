import 'dart:async';
import 'dart:ui';

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

  static const String taskName = 'trosko_background_task';
  static const String taskTag = 'trosko_periodic_sync';

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
    taskName,
    taskTag,
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
  (task, inputData) async {
    try {
      /// Initialize Flutter related tasks
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();

      /// Initialize only what's needed for background task
      await initializeForBackgroundTask();

      /// Show notification after work is done
      await showBackgroundTaskDoneNotification();

      return Future.value(true);
    } catch (_) {
      return Future.value(false);
    }
  },
);

/// Shows notification when background task is done
Future<void> showBackgroundTaskDoneNotification() async {
  try {
    final notificationService = getIt.get<NotificationService>();

    final canShowNotification = notificationService.value.notificationGranted && notificationService.value.listenerGranted && notificationService.value.useNotificationListener;

    if (!canShowNotification) {
      return;
    }

    await notificationService.initializeLocalNotifications();

    final plugin = notificationService.flutterLocalNotificationsPlugin;

    await plugin?.show(
      0,
      'Background task is done',
      null,
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
  } catch (_) {}
}
