import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../util/notification.dart';
import '../util/notification_handler.dart';
import 'logger_service.dart';

class NotificationService extends ValueNotifier<({bool notificationGranted, bool listenerGranted})> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  NotificationService({
    required this.logger,
  }) : super((notificationGranted: false, listenerGranted: false));

  ///
  /// VARIABLES
  ///

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  ///
  /// INIT
  ///

  Future<void> init() async {
    final permissionsGranted = await checkNotificationPermissionAndListener();

    await initializeLocalNotifications();

    if (permissionsGranted) {
      initializeForegroundTask();
      await startService();
    }
  }

  ///
  /// DISPOSE
  ///

  @override
  Future<void> onDispose() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
  }

  ///
  /// METHODS
  ///

  /// Checks for notification permission & listener
  Future<bool> checkNotificationPermissionAndListener() async {
    /// Check if notification permission is enabled
    final notificationPermission = await FlutterForegroundTask.checkNotificationPermission();

    /// Check if notification listener is enabled
    final listenerGranted = await NotificationListenerService.isPermissionGranted();

    /// Update state
    value = (
      notificationGranted: notificationPermission == NotificationPermission.granted,
      listenerGranted: listenerGranted,
    );

    /// Return `true` if all permissions are granted
    return value.notificationGranted && value.listenerGranted;
  }

  /// Initializes [FlutterLocalNotificationsPlugin]
  Future<void> initializeLocalNotifications() async {
    if (flutterLocalNotificationsPlugin != null) {
      return;
    }

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await initializeNotificationPlugin(flutterLocalNotificationsPlugin!);
  }

  /// Requests for notification permission & listener
  Future<bool> askNotificationPermissionAndListener() async {
    /// Request notification permission
    final notificationPermission = await FlutterForegroundTask.requestNotificationPermission();

    /// Android specific notification permission
    if (defaultTargetPlatform == TargetPlatform.android) {
      /// Ignore battery optimization
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      /// Schedule exact alarms
      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }

    /// Request notification listener
    final listenerGranted = await NotificationListenerService.requestPermission();

    /// Update state
    value = (
      notificationGranted: notificationPermission == NotificationPermission.granted,
      listenerGranted: listenerGranted,
    );

    /// Return `true` if all permissions are granted
    return value.notificationGranted && value.listenerGranted;
  }

  /// Initializes [FlutterForegroundTask]
  void initializeForegroundTask() => FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'trosko_channel_id',
      channelName: 'trosko_channel_name',
    ),
    iosNotificationOptions: const IOSNotificationOptions(),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.nothing(),
      autoRunOnBoot: true,
      allowWifiLock: true,
    ),
  );

  /// Starts [FlutterForegroundTask] service
  Future<ServiceRequestResult> startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return const ServiceRequestSuccess();
    }

    return FlutterForegroundTask.startService(
      // TODO: Localize
      notificationTitle: 'Troško is running',
      // TODO: Localize
      notificationText: 'Used to show notifications',
      notificationIcon: const NotificationIcon(
        metaDataName: 'app_icon',
      ),
      callback: startCallback,
    );
  }
}
