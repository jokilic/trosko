import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';
import '../services/hive_service.dart';
import '../services/logger_service.dart';
import '../services/storage_service.dart';

final getIt = GetIt.instance;

/// Registers a class if it's not already initialized
/// Optionally runs a function with newly registered class
void registerIfNotInitialized<T extends Object>(
  T Function() factoryFunc, {
  String? instanceName,
  void Function(T controller)? afterRegister,
}) {
  if (!getIt.isRegistered<T>(instanceName: instanceName)) {
    getIt.registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
    );

    if (afterRegister != null) {
      final instance = getIt.get<T>(instanceName: instanceName);
      afterRegister(instance);
    }
  }
}

void initializeServices() {
  getIt
    ..registerSingletonAsync(
      () async => LoggerService(),
    )
    ..registerSingletonAsync(
      () async {
        final hive = HiveService(
          logger: getIt.get<LoggerService>(),
        );
        await hive.init();
        return hive;
      },
      dependsOn: [LoggerService],
    )
    ..registerSingletonAsync(
      () async {
        final firebase = FirebaseService(
          logger: getIt.get<LoggerService>(),
          auth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance,
        );
        await firebase.init();
        return firebase;
      },
      dependsOn: [LoggerService],
    )
    ..registerSingletonAsync(
      () async => StorageService(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
        firebase: getIt.get<FirebaseService>(),
      ),
      dependsOn: [LoggerService, HiveService, FirebaseService],
    );
}
