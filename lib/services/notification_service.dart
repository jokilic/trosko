// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:get_it/get_it.dart';

import '../util/notification_handler.dart';
import 'hive_service.dart';
import 'logger_service.dart';

class NotificationService extends ValueNotifier<({bool? notificationGranted, bool? listenerGranted, bool useNotificationListener})> implements Disposable {
  static const noChange = Object();

  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  NotificationService({
    required this.logger,
    required this.hive,
  }) : super((
         notificationGranted: null,
         listenerGranted: null,
         useNotificationListener: false,
       ));

  ///
  /// VARIABLES
  ///

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  var initialNotificationHandled = false;
  var notificationListenerInitialized = false;

  ///
  /// INIT
  ///

  Future<void> init() async {
    await initializeLocalNotifications();

    final permissionsGranted = await checkNotificationPermissionAndListener();

    unawaited(
      handleNotificationAppLaunch(),
    );

    if (permissionsGranted) {
      await initializeForegroundTask();
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
    final notificationPermission = await areNotificationsEnabled();
    final listenerGranted = (await NotificationsListener.hasPermission) ?? false;

    /// Update `state`
    updateState(
      notificationGranted: notificationPermission,
      listenerGranted: listenerGranted,
      useNotificationListener: hive.getSettings().useNotificationListener,
    );

    return value.notificationGranted == true && value.listenerGranted == true && value.useNotificationListener;
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

  /// Requests notification posting permission and notification listener access
  Future<bool> askNotificationPermissionAndListener() async {
    /// Request notification permission
    final notificationPermission = await requestNotificationPermission();

    /// Listener not granted, request listener permission
    if (value.listenerGranted != true) {
      await NotificationsListener.openPermissionSettings();
      final listenerGranted = (await NotificationsListener.hasPermission) ?? false;
      updateState(
        listenerGranted: listenerGranted,
      );
    }

    /// Update `state`
    updateState(
      notificationGranted: notificationPermission,
    );

    return value.notificationGranted == true && value.listenerGranted == true && value.useNotificationListener;
  }

  /// Keeps the old service wrapper entrypoint so the surrounding logic can stay unchanged
  Future<void> initializeForegroundTask() async {
    if (notificationListenerInitialized) {
      return;
    }

    await NotificationsListener.initialize(
      callbackHandle: onNotificationEvent,
    );
    notificationListenerInitialized = true;
  }

  /// Starts notification listener service
  Future<bool> startService() async {
    final isRunning = (await NotificationsListener.isRunning) ?? false;

    if (isRunning) {
      return true;
    }

    return (await NotificationsListener.startService(
          foreground: true,
          title: 'foregroundTaskNotificationTitle'.tr(),
          description: 'foregroundTaskNotificationText'.tr(),
          showWhen: false,
        )) ??
        false;
  }

  Future<bool> areNotificationsEnabled() async {
    await initializeLocalNotifications();

    final androidImplementation = flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) {
      return true;
    }

    return (await androidImplementation.areNotificationsEnabled()) ?? false;
  }

  Future<bool> requestNotificationPermission() async {
    await initializeLocalNotifications();

    final androidImplementation = flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) {
      return true;
    }

    return (await androidImplementation.requestNotificationsPermission()) ?? false;
  }

  /// Stops notification listener
  Future<void> stopListener() async {
    final isRunning = (await NotificationsListener.isRunning) ?? false;

    if (isRunning) {
      await NotificationsListener.stopService();
    }
  }

  /// Toggles `useNotificationListener`
  Future<void> toggleUseNotificationListener() async {
    final newUseNotificationListener = !value.useNotificationListener;

    /// Update `state`
    updateState(
      useNotificationListener: newUseNotificationListener,
    );

    await hive.writeSettings(
      hive.getSettings().copyWith(
        useNotificationListener: newUseNotificationListener,
      ),
    );
  }

  /// Updates `state`
  void updateState({
    Object? notificationGranted = noChange,
    Object? listenerGranted = noChange,
    Object? useNotificationListener = noChange,
  }) => value = (
    notificationGranted: identical(notificationGranted, noChange) ? value.notificationGranted : notificationGranted as bool?,
    listenerGranted: identical(listenerGranted, noChange) ? value.listenerGranted : listenerGranted as bool?,
    useNotificationListener: identical(useNotificationListener, noChange) ? value.useNotificationListener : useNotificationListener! as bool,
  );
}
