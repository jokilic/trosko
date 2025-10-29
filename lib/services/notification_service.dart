import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

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

  StreamSubscription<ServiceNotificationEvent>? stream;

  ///
  /// INIT
  ///

  Future<void> init() async {
    final permissionsGranted = await checkNotificationPermissionAndListener();

    if (permissionsGranted) {
      initializeForegroundTask();
      await startService();
      await resetNotificationListener();
    }
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    stream?.cancel();
    FlutterForegroundTask.stopService();
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

    /// Return if all permissions are granted
    return value.notificationGranted && value.listenerGranted;
  }

  /// Requests for notification permission & listener
  Future<void> askNotificationPermissionAndListener() async {
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
  }

  /// Resets notification listener `stream`
  Future<void> resetNotificationListener() async {
    await stream?.cancel();
    stream = null;

    stream = NotificationListenerService.notificationsStream.listen((event) {
      log('[JOSIP] $event');
    });
  }

  /// Initializes [FlutterForegroundTask]
  void initializeForegroundTask() => FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'trosko_channel_id',
      channelName: 'Trosko Notification',
      channelDescription: 'Troško notification appears when the foreground service is running.',
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
        serviceId: 1,
        notificationTitle: 'Troško foreground service is running',
        notificationText: 'Troško to return to the app',
        notificationIcon: const NotificationIcon(
          metaDataName: 'app_icon',
        ),
        notificationButtons: [
          const NotificationButton(
            id: 'add_expense',
            text: 'Add expense',
          ),
        ],
        notificationInitialRoute: '/',
        callback: startCallback,
      );
    }
  }
}
