import 'dart:async';
import 'dart:developer';
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

  static const String taskName = 'trosko_background_task';
  static const String taskTag = 'trosko_periodic_sync';

  // TODO: Remove
  static const String testTaskName = 'trosko_test_task';
  static const String testTaskTag = 'trosko_test_sync';

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
  Future<bool> startTask() async {
    log('[TROSKOO] Registering periodic task');

    try {
      await Workmanager().registerPeriodicTask(
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

      log('[TROSKOO] Periodic task registered');

      return true;
    } catch (e) {
      log('[TROSKOO] Periodic task registration failed: $e');
      return false;
    }
  }

  /// Stops [WorkManager] tasks
  Future<bool> stopTask() async {
    log('[TROSKOO] Stopping all tasks');

    try {
      await Workmanager().cancelAll();

      log('[TROSKOO] All tasks stopped');

      return true;
    } catch (e) {
      log('[TROSKOO] All tasks stopping failed: $e');
      return false;
    }
  }

  // TODO: Remove
  /// Registers a one-off task for testing purposes
  Future<bool> startTestTask() async {
    log('[TROSKOO] Registering one-off test task');

    try {
      await Workmanager().registerOneOffTask(
        testTaskName,
        testTaskTag,
        initialDelay: Duration.zero,
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
      );

      log('[TROSKOO] One-off test task registered');

      return true;
    } catch (e) {
      log('[TROSKOO] One-off test task registration failed: $e');
      return false;
    }
  }
}

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {
  log('[TROSKOO] callbackDispatcher called');

  Workmanager().executeTask(
    (task, inputData) async {
      log('[TROSKOO] callbackDispatcher -> executeTask -> $task');

      try {
        /// Initialize Flutter related tasks
        WidgetsFlutterBinding.ensureInitialized();
        DartPluginRegistrant.ensureInitialized();

        /// Initialize only what's needed for background task
        final initialized = await initializeForBackgroundTask();

        /// Show notification after work is done
        final showedNotification = await showBackgroundTaskDoneNotification();

        if (initialized && showedNotification) {
          log('[TROSKOO] $task finished successfully');
          return Future.value(true);
        } else {
          log('[TROSKOO] $task finished with an error: initialized: $initialized, showedNotification: $showedNotification');
          return Future.value(false);
        }
      } catch (e) {
        log('[TROSKOO] $task finished with an error: $e');
        return Future.value(false);
      }
    },
  );
}

/// Shows notification when background task is done
Future<bool> showBackgroundTaskDoneNotification() async {
  log('[TROSKOO] showBackgroundTaskDoneNotification called');

  try {
    final notificationService = getIt.get<NotificationService>();

    final canShowNotification = notificationService.value.notificationGranted && notificationService.value.listenerGranted && notificationService.value.useNotificationListener;

    if (!canShowNotification) {
      log('[TROSKOO] showBackgroundTaskDoneNotification -> !canShowNotification');
      return false;
    }

    await notificationService.initializeLocalNotifications();

    final plugin = notificationService.flutterLocalNotificationsPlugin;

    await plugin?.show(
      0,
      'Background task is done',
      DateFormat('HH:mm').format(DateTime.now()),
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

    log('[TROSKOO] showBackgroundTaskDoneNotification finished successfully');

    return true;
  } catch (e) {
    log('[TROSKOO] showBackgroundTaskDoneNotification finished with an error: $e');
    return false;
  }
}
