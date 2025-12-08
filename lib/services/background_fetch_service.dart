import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../util/dependencies.dart';
import 'logger_service.dart';
import 'notification_service.dart';

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
      await startTask();
    } else {
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

        /// Show notification after work is done
        await showBackgroundTaskDoneNotification();

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

  /// Show notification after work is done
  await showBackgroundTaskDoneNotification();

  /// Finish task
  await BackgroundFetch.finish(taskId);
}

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
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  } catch (_) {}
}
