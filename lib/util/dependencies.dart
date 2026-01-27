import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/ai_service.dart';
import '../services/firebase_service.dart';
import '../services/hive_service.dart';
import '../services/logger_service.dart';
import '../services/map_service.dart';
import '../services/notification_service.dart';
import '../services/speech_to_text_service.dart';
import '../services/work_manager_service.dart';

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

Future<void> initializeServices() async {
  if (!getIt.isRegistered<LoggerService>()) {
    getIt.registerSingletonAsync(
      () async => LoggerService(),
    );
  }

  if (!getIt.isRegistered<HiveService>()) {
    getIt.registerSingletonAsync(
      () async {
        final hive = HiveService(
          logger: getIt.get<LoggerService>(),
        );
        await hive.init();
        return hive;
      },
      dependsOn: [LoggerService],
    );
  }

  if (!getIt.isRegistered<FirebaseService>()) {
    getIt.registerSingletonAsync(
      () async => FirebaseService(
        logger: getIt.get<LoggerService>(),
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
        googleSignIn: GoogleSignIn.instance,
      ),
      dependsOn: [LoggerService],
    );
  }

  if (!getIt.isRegistered<MapService>()) {
    getIt.registerSingletonAsync(
      () async {
        final useVectorMaps = getIt.get<HiveService>().value.settings?.useVectorMaps;

        final map = MapService(
          logger: getIt.get<LoggerService>(),
        );
        if (useVectorMaps ?? false) {
          await map.init();
        }
        return map;
      },
      dependsOn: [LoggerService, HiveService],
    );
  }

  if (!getIt.isRegistered<SpeechToTextService>()) {
    getIt.registerSingletonAsync(
      () async {
        final useVoice = getIt.get<HiveService>().value.settings?.useVoice;

        final speechToText = SpeechToTextService(
          logger: getIt.get<LoggerService>(),
        );
        if (useVoice ?? false) {
          await speechToText.init();
        }
        return speechToText;
      },
      dependsOn: [LoggerService, HiveService],
    );
  }

  if (!getIt.isRegistered<AIService>()) {
    getIt.registerSingletonAsync(
      () async => AIService(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
        ai: FirebaseAI.googleAI(),
      )..init(),
      dependsOn: [LoggerService, HiveService],
    );
  }

  if (!getIt.isRegistered<NotificationService>()) {
    getIt.registerSingletonAsync(
      () async {
        final notification = NotificationService(
          logger: getIt.get<LoggerService>(),
          hive: getIt.get<HiveService>(),
        );
        if (defaultTargetPlatform == TargetPlatform.android) {
          await notification.init();
        }
        return notification;
      },
      dependsOn: [LoggerService, HiveService],
    );
  }

  if (!getIt.isRegistered<WorkManagerService>()) {
    getIt.registerSingletonAsync(
      () async {
        final notificationValue = getIt.get<NotificationService>().value;
        final notificationsEnabled = notificationValue.notificationGranted && notificationValue.listenerGranted && notificationValue.useNotificationListener;

        final workManager = WorkManagerService(
          logger: getIt.get<LoggerService>(),
          notificationsEnabled: notificationsEnabled,
        );
        if (defaultTargetPlatform == TargetPlatform.android) {
          await workManager.init();
        }
        return workManager;
      },
      dependsOn: [LoggerService, NotificationService],
    );
  }

  /// Wait for initialization to finish
  await getIt.allReady();
}

/// Initializes only the services needed for background task
Future<void> initializeForBackgroundTask() async {
  if (!getItBackground.isRegistered<LoggerService>()) {
    getItBackground.registerSingletonAsync<LoggerService>(
      () async => LoggerService(),
    );
  }

  if (!getItBackground.isRegistered<HiveService>()) {
    getItBackground.registerSingletonAsync<HiveService>(
      () async {
        final hive = HiveService(
          logger: getItBackground.get<LoggerService>(),
        );
        await hive.init();
        return hive;
      },
      dependsOn: [LoggerService],
    );
  }

  if (!getItBackground.isRegistered<NotificationService>()) {
    getItBackground.registerSingletonAsync<NotificationService>(
      () async {
        final notification = NotificationService(
          logger: getItBackground.get<LoggerService>(),
          hive: getItBackground.get<HiveService>(),
        );

        final settings = notification.hive.getSettings();

        notification.updateState(
          useNotificationListener: settings.useNotificationListener,
          notificationGranted: settings.useNotificationListener,
          listenerGranted: settings.useNotificationListener,
        );

        return notification;
      },
      dependsOn: [LoggerService, HiveService],
    );
  }

  /// Wait for initialization to finish
  await getItBackground.allReady();
}
