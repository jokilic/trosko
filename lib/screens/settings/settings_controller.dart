import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/trosko_theme_tag/trosko_theme_tag.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../services/map_service.dart';
import '../../services/notification_service.dart';
import '../../services/speech_to_text_service.dart';
import '../../services/work_manager_service.dart';
import '../../theme/extensions.dart';
import 'widgets/settings_delete_account_modal.dart';

class SettingsController implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseService firebase;
  final NotificationService notification;
  final WorkManagerService workManager;
  final MapService map;
  final SpeechToTextService speechToText;

  SettingsController({
    required this.logger,
    required this.hive,
    required this.firebase,
    required this.notification,
    required this.workManager,
    required this.map,
    required this.speechToText,
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
  Future<void> onPressedVectorMaps() async {
    final settings = hive.getSettings();

    final newUseVectorMaps = !settings.useVectorMaps;

    await hive.writeSettings(
      settings.copyWith(
        useVectorMaps: newUseVectorMaps,
      ),
    );

    if (newUseVectorMaps) {
      await map.init();
    }
  }

  /// Triggered when the user presses the voice [ListTile]
  Future<void> onPressedVoice() async {
    final settings = hive.getSettings();

    final newUseVoice = !settings.useVoice;

    await hive.writeSettings(
      settings.copyWith(
        useVoice: newUseVoice,
      ),
    );

    if (newUseVoice) {
      await speechToText.init();
    }
  }

  /// Triggered when the user presses the icons [ListTile]
  Future<void> onPressedColorfulIcons() async {
    final settings = hive.getSettings();

    final newUseColorfulIcons = !settings.useColorfulIcons;

    await hive.writeSettings(
      settings.copyWith(
        useColorfulIcons: newUseColorfulIcons,
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
  Future<void> onPressedThemeData({
    required ThemeData? newThemeData,
  }) async => hive.writeSettings(
    hive.getSettings().copyWith(
      troskoThemeId: newThemeData?.extension<TroskoThemeTag>()?.id,
    ),
  );

  /// Triggered when the user presses some [Color]
  Future<void> onPressedPrimaryColor(Color newPrimaryColor) async => hive.writeSettings(
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

  /// Triggered when the user presses the delete account button
  Future<bool> onDeleteAccountPressed(BuildContext context) async {
    /// Get `authProvider`
    final authProvider = firebase.authProvider;
    final isNotEmailProvider = authProvider == AuthProvider.google || authProvider == AuthProvider.apple;

    /// Show [SettingsDeleteAccountModal] for email users
    final value = await showModalBottomSheet<({String email, String password, bool shouldDelete})>(
      context: context,
      backgroundColor: context.colors.scaffoldBackground,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      builder: (context) => SettingsDeleteAccountModal(
        deleteWord: isNotEmailProvider ? 'settingsDeleteAccountDeleteWordModalWord'.tr() : null,
        userEmail: !isNotEmailProvider ? firebase.userEmail : null,
        key: const ValueKey('delete-account-modal'),
      ),
    );

    /// User should be deleted
    if (value?.shouldDelete ?? false) {
      /// Delete `user`
      final isDeletedUser = await deleteUser(
        email: value?.email,
        password: value?.password,
      );

      return isDeletedUser;
    }

    return false;
  }

  /// Deletes [Firebase] user & clears [Hive]
  /// For email/password users, [email] and [password] are required
  /// For Google/Apple users, reauthentication is handled automatically via OAuth
  Future<bool> deleteUser({
    String? email,
    String? password,
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
