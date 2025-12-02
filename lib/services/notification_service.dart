import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../util/notification_handler.dart';
import 'hive_service.dart';
import 'logger_service.dart';

class NotificationService extends ValueNotifier<({bool notificationGranted, bool listenerGranted, bool useNotificationListener})> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  NotificationService({
    required this.logger,
    required this.hive,
  }) : super((
         notificationGranted: false,
         listenerGranted: false,
         useNotificationListener: false,
       ));

  ///
  /// VARIABLES
  ///

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  var initialNotificationHandled = false;

  ///
  /// INIT
  ///

  Future<void> init() async {
    final permissionsGranted = await checkNotificationPermissionAndListener();

    await initializeLocalNotifications();
    unawaited(
      handleNotificationAppLaunch(),
    );

    if (permissionsGranted) {
      initializeForegroundTask();
      await startService();
    } else {
      await stopListener();
    }
  }

  ///
  /// DISPOSE
  ///

  @override
  Future<void> onDispose() async {
    await stopListener();
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
    updateState(
      notificationGranted: notificationPermission == NotificationPermission.granted,
      listenerGranted: listenerGranted,
      useNotificationListener: hive.getSettings().useNotificationListener ?? false,
    );

    /// Return `true` if all permissions are granted
    return value.notificationGranted && value.listenerGranted && value.useNotificationListener;
  }

  /// Initializes [FlutterLocalNotificationsPlugin]
  Future<void> initializeLocalNotifications() async {
    if (flutterLocalNotificationsPlugin != null) {
      return;
    }

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await initializeNotificationPlugin(flutterLocalNotificationsPlugin!);
  }

  /// Handles launching application if opened through notification
  Future<void> handleNotificationAppLaunch() async {
    if (initialNotificationHandled || flutterLocalNotificationsPlugin == null) {
      return;
    }

    final launchDetails = await flutterLocalNotificationsPlugin!.getNotificationAppLaunchDetails();
    final notificationResponse = launchDetails?.notificationResponse;

    if (!(launchDetails?.didNotificationLaunchApp ?? true) || notificationResponse == null) {
      return;
    }

    initialNotificationHandled = true;

    await handlePressedNotification(
      payload: notificationResponse.payload,
    );
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
    if (!value.listenerGranted) {
      final listenerGranted = await NotificationListenerService.requestPermission();
      updateState(
        listenerGranted: listenerGranted,
      );
    }

    /// Update state
    updateState(
      notificationGranted: notificationPermission == NotificationPermission.granted,
    );

    /// Return `true` if all permissions are granted
    return value.notificationGranted && value.listenerGranted && value.useNotificationListener;
  }

  /// Initializes [FlutterForegroundTask]
  void initializeForegroundTask() => FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'trosko_listener_channel_id',
      channelName: 'Troško listener',
      channelDescription: 'Listener shown by the Troško app',
      channelImportance: NotificationChannelImportance.MAX,
      priority: NotificationPriority.MAX,
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
      notificationTitle: 'foregroundTaskNotificationTitle'.tr(),
      notificationText: 'foregroundTaskNotificationText'.tr(),
      notificationIcon: const NotificationIcon(
        metaDataName: 'app_icon',
      ),
      callback: startCallback,
    );
  }

  /// Stops notification listener
  Future<void> stopListener() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
  }

  /// Toggles `useNotificationListener`
  Future<void> toggleUseNotificationListener() async {
    final newUseNotificationListener = !value.useNotificationListener;

    /// Update state
    updateState(
      useNotificationListener: newUseNotificationListener,
    );

    /// Store `value` into [Hive]
    await hive.writeSettings(
      hive.getSettings().copyWith(
        useNotificationListener: newUseNotificationListener,
      ),
    );
  }

  /// Updates `state`
  void updateState({
    bool? notificationGranted,
    bool? listenerGranted,
    bool? useNotificationListener,
  }) => value = (
    notificationGranted: notificationGranted ?? value.notificationGranted,
    listenerGranted: listenerGranted ?? value.listenerGranted,
    useNotificationListener: useNotificationListener ?? value.useNotificationListener,
  );
}
