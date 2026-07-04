import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../util/dependencies.dart';
import '../util/localization.dart';
import '../util/notification_handler.dart';
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
  /// VARIABLES
  ///

  static const uniqueName = 'trosko_background_task';
  static const taskName = 'trosko_periodic_task';

  ///
  /// INIT
  ///

  Future<void> init() async {
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
  final logger = LoggerService();
  var status = 'Task completed';

  try {
    logger.i('Background fetch started: $taskId');

    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    logger.d('Background fetch Flutter bindings initialized');

    /// Initialize only what's needed for background task
    await initializeForBackgroundTask();
    logger.d('Background fetch services initialized');

    /// Initialize localization
    await initializeLocalization();
    logger.d('Background fetch localization initialized');

    /// Recheck the real Android permission state before trying to revive the service
    final notificationPermission = await FlutterForegroundTask.checkNotificationPermission();
    final listenerGranted = await NotificationListenerService.isPermissionGranted();
    logger.d('Background fetch permissions checked: notification=$notificationPermission, listener=$listenerGranted');

    /// Restart notification listener foreground service if enabled
    final notification = getItBackground.get<NotificationService>();

    final notificationsEnabled = notification.value.useNotificationListener && notificationPermission == NotificationPermission.granted && listenerGranted;
    logger.d('Background fetch notification listener enabled: $notificationsEnabled');

    if (notificationsEnabled) {
      notification
        ..updateState(
          notificationGranted: true,
          listenerGranted: true,
        )
        ..initializeForegroundTask();

      await notification.ensureServiceRunning(
        forceRestart: true,
      );

      status = 'Service restarted';
      logger.i('Background fetch service restarted');
    } else {
      notification.updateState(
        notificationGranted: notificationPermission == NotificationPermission.granted,
        listenerGranted: listenerGranted,
      );

      status =
          'Service skipped: notification=${notificationPermission == NotificationPermission.granted}, listener=$listenerGranted, enabled=${notification.value.useNotificationListener}';
      logger.w('Background fetch service skipped: $status');
    }
  } catch (error, stackTrace) {
    status = 'Error: $error';
    logger.e('Background fetch failed: $error\n$stackTrace');
  } finally {
    logger.i('Background fetch finishing: $status');

    await showBackgroundFetchFinishedNotification(
      status: status,
      logger: logger,
    );

    await BackgroundFetch.finish(taskId);
  }
}

@pragma('vm:entry-point')
Future<void> showBackgroundFetchFinishedNotification({
  required String status,
  required LoggerService logger,
}) async {
  try {
    /// Make the notification helper resilient when the task fails before setup completes.
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    final plugin = FlutterLocalNotificationsPlugin();
    await initializeNotificationPlugin(plugin);

    final now = DateTime.now();

    await plugin.show(
      id: now.millisecondsSinceEpoch % 1000000000,
      title: now.toIso8601String(),
      body: status,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'trosko_background_fetch_channel_id',
          'Troško background fetch',
          channelDescription: 'Background fetch status notifications shown by the Troško app',
          styleInformation: BigTextStyleInformation(
            status,
            contentTitle: 'Finished',
          ),
          category: AndroidNotificationCategory.service,
          importance: Importance.max,
          priority: Priority.max,
          ticker: 'ticker',
        ),
      ),
    );
  } catch (error, stackTrace) {
    logger.e('Background fetch finish notification failed: $error\n$stackTrace');
  }
}
