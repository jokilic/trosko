import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/ai_service.dart';
import '../services/background_fetch_service.dart';
import '../services/firebase_service.dart';
import '../services/hive_service.dart';
import '../services/map_service.dart';
import '../services/notification_service.dart';
import '../services/speech_to_text_service.dart';

final getIt = GetIt.instance;
final getItBackground = GetIt.asNewInstance();

/// Registers a class if it's not already initialized
/// Optionally runs a function with newly registered class
T registerIfNotInitialized<T extends Object>(
  T Function() factoryFunc, {
  String? instanceName,
  void Function(T controller)? afterRegister,
}) {
  if (!getIt.isRegistered<T>(instanceName: instanceName)) {
    getIt.registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
      onCreated: afterRegister != null ? (instance) => afterRegister(instance) : null,
    );
  }

  return getIt.get<T>(instanceName: instanceName);
}

/// Unregisters a class if it's not already disposed
/// Optionally runs a function with newly unregistered class
void unRegisterIfNotDisposed<T extends Object>({
  String? instanceName,
  void Function(T controller)? afterUnregister,
}) {
  if (getIt.isRegistered<T>(instanceName: instanceName)) {
    getIt.unregister<T>(
      disposingFunction: afterUnregister,
      instanceName: instanceName,
    );
  }
}

/// Initializes services required before showing UI
Future<void> initializeCriticalServices() async {
  if (!getIt.isRegistered<HiveService>()) {
    getIt.registerSingletonAsync(
      () async {
        final hive = HiveService();
        await hive.init();
        return hive;
      },
    );
  }

  if (!getIt.isRegistered<FirebaseService>()) {
    getIt.registerSingletonAsync(
      () async => FirebaseService(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
        googleSignIn: GoogleSignIn.instance,
      ),
    );
  }

  /// Wait for startup-critical initialization to finish
  await getIt.allReady();
}

/// Register non-critical services so they are available to screens immediately
void registerDeferredServices() {
  final hive = getIt.get<HiveService>();

  if (!getIt.isRegistered<MapService>()) {
    getIt.registerSingleton(
      MapService(),
    );
  }

  if (!getIt.isRegistered<SpeechToTextService>()) {
    getIt.registerSingleton(
      SpeechToTextService(),
    );
  }

  if (!getIt.isRegistered<AIService>()) {
    getIt.registerSingleton(
      AIService(
        hive: hive,
        ai: FirebaseAI.googleAI(),
      ),
    );
  }

  if (!getIt.isRegistered<NotificationService>()) {
    getIt.registerSingleton(
      NotificationService(
        hive: hive,
      ),
    );
  }

  if (!getIt.isRegistered<BackgroundFetchService>()) {
    getIt.registerSingleton(
      BackgroundFetchService(),
    );
  }
}

/// Initializes services after showing UI
Future<void> initializeDeferredServices() async {
  try {
    final hiveSettings = getIt.get<HiveService>().getSettings();
    final futures = <Future<void>>[];

    if (hiveSettings.useVectorMaps) {
      futures.add(
        getIt.get<MapService>().init(),
      );
    }

    if (hiveSettings.useVoice) {
      futures.add(
        getIt.get<SpeechToTextService>().init(),
      );
    }

    getIt.get<AIService>().init();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final notification = getIt.get<NotificationService>();
      await notification.init();

      final notificationValue = notification.value;
      final notificationsEnabled = notificationValue.notificationGranted && notificationValue.listenerGranted && notificationValue.useNotificationListener;

      futures.add(
        getIt.get<BackgroundFetchService>().init(
          notificationsEnabled: notificationsEnabled,
        ),
      );
    }

    await Future.wait(futures);
  } catch (e) {
    log('initializeDeferredServices() -> $e');
  }
}

/// Initializes only the services needed for background task
Future<void> initializeForBackgroundTask() async {
  if (!getItBackground.isRegistered<HiveService>()) {
    getItBackground.registerSingletonAsync<HiveService>(
      () async {
        final hive = HiveService();
        await hive.init();
        return hive;
      },
    );
  }

  if (!getItBackground.isRegistered<NotificationService>()) {
    getItBackground.registerSingletonAsync<NotificationService>(
      () async {
        final notification = NotificationService(
          hive: getItBackground.get<HiveService>(),
        );

        final settings = notification.hive.getSettings();
        final useNotificationListener = settings.useNotificationListener;

        notification.updateState(
          useNotificationListener: useNotificationListener,
          notificationGranted: false,
          listenerGranted: false,
        );

        return notification;
      },
      dependsOn: [HiveService],
    );
  }

  /// Wait for initialization to finish
  await getItBackground.allReady();
}
