import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../util/notification_handler.dart';
import 'logger_service.dart';

const promajaPackageName = 'com.josipkilic.promaja';

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
  var taskDataCallbackRegistered = false;

  ///
  /// INIT
  ///

  Future<void> init() async {
    final permissionsGranted = await checkNotificationPermissionAndListener();

    await initializeLocalNotifications();

    if (permissionsGranted) {
      initializeForegroundTask();
      await startService();
      resetNotificationListener();
    }
  }

  ///
  /// DISPOSE
  ///

  @override
  Future<void> onDispose() async {
    if (taskDataCallbackRegistered) {
      FlutterForegroundTask.removeTaskDataCallback(handleTaskData);
      taskDataCallbackRegistered = false;
    }

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

  /// Requests for notification permission & listener
  Future<bool> askNotificationPermissionAndListener() async {
    /// Request notification permission
    final notificationPermission =
        await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission() ?? false;

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
      notificationGranted: notificationPermission,
      listenerGranted: listenerGranted,
    );

    /// Return `true` if all permissions are granted
    return value.notificationGranted && value.listenerGranted;
  }

  /// Initializes [FlutterLocalNotifications]
  Future<void> initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin?.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
    );
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
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Troško foreground service is running',
        notificationText: 'Used to trigger Troško when Promaja sends notification',
        notificationIcon: const NotificationIcon(
          metaDataName: 'app_icon',
        ),
        callback: startCallback,
      );
    }
  }

  /// Shows notification using [FlutterLocalNotifications]
  void showNotification({
    required String title,
    required String body,
  }) => flutterLocalNotificationsPlugin?.show(
    0,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'trosko_channel_id',
        'trosko_channel_name',
        category: AndroidNotificationCategory.service,
      ),
    ),
  );

  /// Ensures the communication callback is registered so background events reach the UI isolate
  void resetNotificationListener() {
    registerTaskDataCallback();
  }

  /// Registers communication callback
  void registerTaskDataCallback() {
    if (taskDataCallbackRegistered) {
      FlutterForegroundTask.removeTaskDataCallback(handleTaskData);
    }

    FlutterForegroundTask.addTaskDataCallback(handleTaskData);
    taskDataCallbackRegistered = true;
  }

  /// Handler for incoming notifications
  void handleTaskData(Object? data) {
    log('handleTaskData -> $data');

    if (data is! Map) {
      return;
    }

    final shouldShow = data[troskoNotificationPayloadShouldShowKey] == true;
    if (!shouldShow) {
      return;
    }

    final title = data[troskoNotificationPayloadTitleKey] as String? ?? defaultNotificationTitle;
    final body = data[troskoNotificationPayloadBodyKey] as String? ?? defaultNotificationBody;

    showNotification(
      title: 'NotificationService -> handleTaskData()',
      body: '$title -> $body',
    );
  }
}
