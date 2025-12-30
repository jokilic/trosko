import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/trosko_theme_tag/trosko_theme_tag.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../services/notification_service.dart';
import '../../services/work_manager_service.dart';

class SettingsController implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseService firebase;
  final NotificationService notification;
  final WorkManagerService workManager;

  SettingsController({
    required this.logger,
    required this.hive,
    required this.firebase,
    required this.notification,
    required this.workManager,
  });

  ///
  /// VARIABLES
  ///

  late final nameTextEditingController = TextEditingController(
    text: hive.value.username,
  );

  final primaryColorsKeys = <Color, GlobalKey>{};

  ///
  /// INIT
  ///

  void init() {
    final settings = hive.getSettings();

    /// Scroll to `primaryColor`
    if (settings.primaryColor != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = primaryColorsKeys[settings.primaryColor];
        final ctx = key?.currentContext;

        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0.5,
          );
        }
      });
    }
  }

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

  /// Triggered when the user presses the notification [ListTile]
  Future<void> onPressedNotifications() async {
    await notification.toggleUseNotificationListener();

    final permissionsGranted = await notification.askNotificationPermissionAndListener();

    await notification.initializeLocalNotifications();
    await notification.handleNotificationAppLaunch();

    if (permissionsGranted) {
      notification.initializeForegroundTask();
      await notification.startService();
    } else {
      await notification.stopListener();
    }

    await workManager.toggleTask(
      notificationsEnabled: permissionsGranted,
    );
  }

  /// Triggered when the user presses the vector [ListTile]
  void onPressedVectorMaps() {
    final settings = hive.getSettings();

    final newUseVectorMaps = !settings.useVectorMaps;

    hive.writeSettings(
      settings.copyWith(
        useVectorMaps: newUseVectorMaps,
      ),
    );
  }

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
  void onPressedThemeData({
    required ThemeData? newThemeData,
  }) => hive.writeSettings(
    hive.getSettings().copyWith(
      troskoThemeId: newThemeData?.extension<TroskoThemeTag>()?.id,
    ),
  );

  /// Triggered when the user presses some [Color]
  void onPressedPrimaryColor(Color newPrimaryColor) => hive.writeSettings(
    hive.getSettings().copyWith(
      primaryColor: newPrimaryColor,
    ),
  );

  /// Triggered when the user presses a flag
  Future<void> onPressedLanguage({
    required String languageCode,
    required BuildContext context,
  }) async => context.setLocale(Locale(languageCode));

  /// Refetches all data from [Firebase] and stores into [Hive]
  Future<void> refetchFirebaseDataIntoHive() async {
    final username = await firebase.getUsername();
    final transactions = await firebase.getTransactions();
    final categories = await firebase.getCategories();
    final locations = await firebase.getLocations();

    await hive.storeDataFromFirebase(
      username: username,
      transactions: transactions,
      categories: categories,
      locations: locations,
    );
  }

  /// Logs out of [Firebase] & clears [Hive]
  Future<void> logOut() async {
    firebase.logOut();
    await hive.clearEverything();
  }

  /// Deletes [Firebase] user & clears [Hive]
  Future<bool> deleteUser({
    required String email,
    required String password,
  }) async {
    final isUserDeleted = await firebase.deleteUser(
      email: email,
      password: password,
    );

    if (isUserDeleted) {
      await hive.clearEverything();
      return true;
    }

    return false;
  }
}
