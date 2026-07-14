import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';

import '../util/dependencies.dart';
import '../util/localization.dart';
import 'notification_service.dart';

class BackgroundFetchService {
  ///
  /// VARIABLES
  ///

  static const uniqueName = 'trosko_background_task';
  static const taskName = 'trosko_periodic_task';

  ///
  /// INIT
  ///

  Future<void> init({required bool notificationsEnabled}) async {
    await initializeBackgroundFetch();
    await toggleTask(
      notificationsEnabled: notificationsEnabled,
    );
  }

  ///
  /// METHODS
  ///

  /// Initializes [BackgroundFetch]
  Future<void> initializeBackgroundFetch() async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 30,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiredNetworkType: NetworkType.NONE,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      handleBackgroundFetch,
      BackgroundFetch.finish,
    );

    await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

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

  /// Starts [BackgroundFetch] periodic events
  Future<void> startTask() async => BackgroundFetch.start();

  /// Stops [BackgroundFetch] tasks
  Future<void> stopTask() async => BackgroundFetch.stop();
}

@pragma('vm:entry-point')
Future<void> backgroundFetchHeadlessTask(HeadlessEvent task) async {
  final taskId = task.taskId;

  if (task.timeout) {
    await BackgroundFetch.finish(taskId);
    return;
  }

  await handleBackgroundFetch(taskId);
}

@pragma('vm:entry-point')
Future<void> handleBackgroundFetch(String taskId) async {
  try {
    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    /// Initialize only what's needed for background task
    await initializeForBackgroundTask();

    /// Initialize localization
    await initializeLocalization();

    /// Restart notification listener if enabled in settings
    final notification = getItBackground.get<NotificationService>();

    final notificationsEnabled = notification.value.useNotificationListener;

    if (notificationsEnabled) {
      notification.initializeForegroundTask();

      await notification.ensureServiceRunning(
        forceRestart: true,
      );
    }
  } finally {
    await BackgroundFetch.finish(taskId);
  }
}
