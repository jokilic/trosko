import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'logger_service.dart';

class BackgroundFetchService {
  final LoggerService logger;
  final bool notificationsEnabled;

  BackgroundFetchService({
    required this.logger,
    required this.notificationsEnabled,
  });

  ///
  /// INIT
  ///

  Future<void> init() async {
    await initializeHeadlessTask();
    await toggleTask(
      notificationsEnabled: notificationsEnabled,
    );
  }

  ///
  /// METHODS
  ///

  /// Toggle task, depending on notifications being active
  Future<void> toggleTask({required bool notificationsEnabled}) async {
    if (notificationsEnabled) {
      log('Starting task');
      await startTask();
    } else {
      log('Stopping task');
      await stopTask();
    }
  }

  Future<void> startTask() async => BackgroundFetch.start();

  Future<void> stopTask() async => BackgroundFetch.stop();

  Future<void> initializeHeadlessTask() async {
    /// Register headless task
    await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

    /// Configure [BackgroundFetch]
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 30,
        startOnBoot: true,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
      ),

      /// Task logic
      (taskId) async {
        /// Initialize Flutter related tasks
        WidgetsFlutterBinding.ensureInitialized();
        DartPluginRegistrant.ensureInitialized();

        /// Initialize all functionality
        await initializeBeforeAppStart();

        /// Finish task
        await BackgroundFetch.finish(taskId);
      },

      /// Task timeout logic
      (taskId) async {
        await BackgroundFetch.finish(taskId);
      },
    );
  }
}

@pragma('vm:entry-point')
Future<void> backgroundFetchHeadlessTask(HeadlessTask task) async {
  final taskId = task.taskId;
  final isTimeout = task.timeout;

  /// Task is timed out, finish it immediately
  if (isTimeout) {
    await BackgroundFetch.finish(taskId);
    return;
  }

  ///
  /// Task logic
  ///

  /// Initialize Flutter related tasks
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  /// Initialize all functionality
  await initializeBeforeAppStart();

  /// Finish task
  await BackgroundFetch.finish(taskId);
}
