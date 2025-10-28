import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import 'logger_service.dart';

class NotificationService extends ValueNotifier<bool> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  NotificationService({
    required this.logger,
  }) : super(false);

  ///
  /// VARIABLES
  ///

  StreamSubscription<ServiceNotificationEvent>? stream;

  ///
  /// INIT
  ///

  Future<void> init() async {
    await checkPermissionStartListening();
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    stream?.cancel();
  }

  ///
  /// METHODS
  ///

  /// Checks for notification permissions and starts listening if enabled
  Future<void> checkPermissionStartListening() async {
    /// Check if notification permission is enabled & store in `state`
    value = await NotificationListenerService.isPermissionGranted();

    /// Permission is enabled, start listening for notifications
    if (value) {
      await resetNotificationListener();
    }
  }

  /// Asks for notification permissions and starts listening if enabled
  Future<void> askPermissionStartListening() async {
    /// Request notification permission
    value = await NotificationListenerService.requestPermission();

    /// Permission is enabled, start listening for notifications
    if (value) {
      await resetNotificationListener();
    }
  }

  Future<void> resetNotificationListener() async {
    await stream?.cancel();
    stream = null;

    stream = NotificationListenerService.notificationsStream.listen((event) {
      log('[JOSIP] $event');
    });
  }
}
