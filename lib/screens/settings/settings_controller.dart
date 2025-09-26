import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../util/theme.dart';

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

  /// Triggered when the user submits a new `name`
  Future<void> onSubmittedName(String newName) async {
    await hive.writeUsername(
      newName.trim(),
    );

    unawaited(
      firebase.writeUsername(
        newUsername: newName,
      ),
    );
  }

  /// Triggered when the user presses some [ThemeMode]
  void onPressedThemeMode(ThemeMode newThemeMode) => hive.writeSettings(
    hive.getSettings().copyWith(
      themeModeInt: getThemeModeInt(
        themeMode: newThemeMode,
      ),
    ),
  );

  /// Logs out of [Firebase] & clears [Hive]
  Future<void> logOut() async {
    firebase.logOut();
    await hive.clearEverything();
  }

  /// Triggered when the user presses a flag
  void onPressedLanguage({
    required String languageCode,
    required BuildContext context,
  }) => context.setLocale(Locale(languageCode));
}
