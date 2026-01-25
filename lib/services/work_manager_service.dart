import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import '../util/dependencies.dart';
import '../util/localization.dart';
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
  (_, __) async {
    try {
      /// Initialize Flutter related tasks
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();

      /// Initialize only what's needed for background task
      await initializeForBackgroundTask();

      /// Initialize localization
      await initializeLocalization();

      /// Restart notification listener foreground service if enabled
      final notification = getItBackground.get<NotificationService>();

      if (notification.value.useNotificationListener) {
        notification.initializeForegroundTask();
        await notification.startService();
      }

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  },
);
