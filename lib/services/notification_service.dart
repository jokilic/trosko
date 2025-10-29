import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  /// Resets notification listener `stream`
  Future<void> resetNotificationListener() async {
    await stream?.cancel();
    stream = null;

    stream = NotificationListenerService.notificationsStream.listen((event) {
      log('[JOSIP] Listener -> $event');
    });
  }

  /// Initializes [FlutterLocalNotifications]
  Future<void> initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin?.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );
  }

  /// Initializes [FlutterForegroundTask]
  void initializeForegroundTask() => FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'trosko_channel_id',
      channelName: 'trosko_channel_name',
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

  /// Shows notification using [FlutterLocalNotifications]
  void showNotification() => flutterLocalNotificationsPlugin?.show(
    0,
    'plain title',
    'plain body',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'trosko_channel_id',
        'trosko_channel_name',
        actions: [
          AndroidNotificationAction(
            'add_expense',
            'Add expense',
          ),
        ],
        category: AndroidNotificationCategory.service,
        channelDescription: "Troško notification appears when the it's triggered to show.",
        importance: Importance.max,
        priority: Priority.max,
      ),
    ),
    payload: 'item x',
  );
}
