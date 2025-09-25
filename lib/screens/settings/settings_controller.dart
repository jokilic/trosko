import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class SettingsController implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseService firebase;

  SettingsController({
    required this.logger,
    required this.hive,
    required this.firebase,
  });

  ///
  /// VARIABLES
  ///

  late final nameTextEditingController = TextEditingController(
    text: hive.value.username,
  );

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    nameTextEditingController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Logs out of [Firebase] & clears [Hive]
  Future<void> logOut() async {
    firebase.logOut();
    await hive.clearEverything();
  }
}
