import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/colors.dart';
import '../../constants/icons.dart';
import '../../models/trosko_theme_tag/trosko_theme_tag.dart';
import '../../routing.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../services/notification_service.dart';
import '../../services/work_manager_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/app_version.dart';
import '../../util/color.dart';
import '../../util/dependencies.dart';
import '../../util/sounds.dart';
import '../../util/theme.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_text_field.dart';
import 'settings_controller.dart';
import 'widgets/settings_categories.dart';
import 'widgets/settings_delete_account_modal.dart';
import 'widgets/settings_languages.dart';
import 'widgets/settings_list_tile.dart';
import 'widgets/settings_primary_colors.dart';
import 'widgets/settings_themes.dart';

class SettingsScreen extends WatchingStatefulWidget {
  final Function() onStateUpdateTriggered;

  const SettingsScreen({
    required this.onStateUpdateTriggered,
    required super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<SettingsController>(
      () => SettingsController(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
        firebase: getIt.get<FirebaseService>(),
        notification: getIt.get<NotificationService>(),
        workManager: getIt.get<WorkManagerService>(),
      ),
      afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<SettingsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = getIt.get<SettingsController>();
    final hiveService = getIt.get<HiveService>();

    final hive = watchIt<HiveService>();
    final notification = watchIt<NotificationService>().value;

    final notificationGranted = notification.notificationGranted;
    final listenerGranted = notification.listenerGranted;
    final useNotificationListener = notification.useNotificationListener;

    final permissionsGranted = notificationGranted && listenerGranted && useNotificationListener;

    final categories = hive.value.categories;
    final settings = hive.value.settings;

    final primaryColor = settings?.primaryColor ?? context.colors.buttonPrimary;

    final activeTroskoThemeId = getTroskoTheme(
      id: settings?.troskoThemeId,
      primaryColor: primaryColor,
    )?.extension<TroskoThemeTag>()?.id;

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          ///
          /// APP BAR
          ///
          TroskoAppBar(
            leadingWidget: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                highlightColor: context.colors.buttonBackground,
              ),
              icon: PhosphorIcon(
                PhosphorIcons.arrowLeft(
                  PhosphorIconsStyle.bold,
                ),
                color: context.colors.text,
                size: 28,
              ),
            ),
            smallTitle: 'settingsTitle'.tr(),
            bigTitle: 'settingsTitle'.tr(),
            bigSubtitle: 'settingsSubtitle'.tr(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 4),
          ),

          ///
          /// THEME TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsTheme'.tr(),
                style: context.textStyles.homeTitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          ///
          /// THEMES
          ///
          SettingsThemes(
            primaryColor: primaryColor,
            activeTroskoThemeId: activeTroskoThemeId,
            onPressedThemeData: (themeData) {
              HapticFeedback.lightImpact();
              settingsController.onPressedThemeData(
                newThemeData: themeData,
              );
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          ///
          /// PRIMARY COLOR TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsPrimaryColor'.tr(),
                style: context.textStyles.homeTitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          ///
          /// PRIMARY COLORS
          ///
          SettingsPrimaryColors(
            onGenerateKey: settingsController.primaryColorsKeys.putIfAbsent,
            primaryColors: primaryColors,
            activePrimaryColor: settings?.primaryColor,
            onPressedPrimaryColor: (primaryColor) {
              HapticFeedback.lightImpact();
              settingsController.onPressedPrimaryColor(primaryColor);
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          ///
          /// LANGUAGE TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsLanguage'.tr(),
                style: context.textStyles.homeTitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          ///
          /// LANGUAGES
          ///
          SettingsLanguages(
            activeLanguageCode: context.locale.languageCode,
            onPressedLanguageCode: (languageCode) async {
              unawaited(
                HapticFeedback.lightImpact(),
              );

              await settingsController.onPressedLanguage(
                languageCode: languageCode,
                context: context,
              );
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => widget.onStateUpdateTriggered(),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          ///
          /// CATEGORIES TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsCategoryPosition'.tr(),
                style: context.textStyles.homeTitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          ///
          /// CATEGORIES
          ///
          SettingsCategories(
            categories: categories,
            onReorderCategories: hiveService.updateCategoriesOrder,
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          if (defaultTargetPlatform == TargetPlatform.android) ...[
            ///
            /// NOTIFICATIONS TITLE
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'settingsNotifications'.tr(),
                  style: context.textStyles.homeTitle,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 12),
            ),

            ///
            /// NOTIFICATIONS LIST TILE
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: SettingsListTile(
                  onPressed: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );

                    await settingsController.onPressedNotifications();
                  },
                  title: 'settingsNotificationsTitle'.tr(),
                  subtitle: 'settingsNotificationsSubtitle'.tr(),
                  trailingWidget: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: permissionsGranted ? context.colors.buttonPrimary : context.colors.delete,
                        ),
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        permissionsGranted ? 'settingsNotificationsOn'.tr().toUpperCase() : 'settingsNotificationsOff'.tr().toUpperCase(),
                        style: context.textStyles.homeTransactionTime,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 12),
            ),

            ///
            /// NOTIFICATIONS TEXT
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'settingsNotificationsText'.tr(),
                  style: context.textStyles.homeTransactionNote,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'settingsNotificationsText2'.tr(),
                  style: context.textStyles.homeTransactionNote,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            // TODO: Remove

            ///
            /// TEST TASK BUTTON
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      unawaited(
                        HapticFeedback.lightImpact(),
                      );

                      await settingsController.onPressedTestTask(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colors.buttonPrimary,
                      foregroundColor: getWhiteOrBlackColor(
                        backgroundColor: context.colors.buttonPrimary,
                        whiteColor: TroskoColors.lightThemeWhiteBackground,
                        blackColor: TroskoColors.lightThemeBlackText,
                      ),
                      overlayColor: context.colors.buttonBackground,
                      disabledBackgroundColor: context.colors.disabledBackground,
                      disabledForegroundColor: context.colors.disabledText,
                    ),
                    child: Text(
                      'Test-task'.tr().toUpperCase(),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 8),
            ),

            ///
            /// TEST TASK TEXT
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Pressing this button will register a test-task.',
                  style: context.textStyles.homeTransactionNote,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],

          ///
          /// ACCOUNT MANAGEMENT TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsAccountManagement'.tr(),
                style: context.textStyles.homeTitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          ///
          /// NAME
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: TroskoTextField(
                onSubmitted: settingsController.onSubmittedName,
                controller: settingsController.nameTextEditingController,
                labelText: 'settingsName'.tr(),
                autofillHints: const [AutofillHints.name],
                keyboardType: TextInputType.name,
                textAlign: TextAlign.left,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          ///
          /// NAME TEXT
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsNameText'.tr(),
                style: context.textStyles.homeTransactionNote,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsNameText2'.tr(),
                style: context.textStyles.homeTransactionNote,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          ///
          /// REFRESH BUTTON
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );

                    await settingsController.refetchFirebaseDataIntoHive();
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => widget.onStateUpdateTriggered(),
                    );
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.buttonPrimary,
                    foregroundColor: getWhiteOrBlackColor(
                      backgroundColor: context.colors.buttonPrimary,
                      whiteColor: TroskoColors.lightThemeWhiteBackground,
                      blackColor: TroskoColors.lightThemeBlackText,
                    ),
                    overlayColor: context.colors.buttonBackground,
                    disabledBackgroundColor: context.colors.disabledBackground,
                    disabledForegroundColor: context.colors.disabledText,
                  ),
                  child: Text(
                    'settingsRefreshData'.tr().toUpperCase(),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          ///
          /// REFRESH TEXT
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsRefreshDataText'.tr(),
                style: context.textStyles.homeTransactionNote,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsRefreshDataText2'.tr(),
                style: context.textStyles.homeTransactionNote,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          ///
          /// LOGOUT BUTTON
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );

                    await settingsController.logOut();
                    openLogin(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.delete,
                    foregroundColor: getWhiteOrBlackColor(
                      backgroundColor: context.colors.delete,
                      whiteColor: TroskoColors.lightThemeWhiteBackground,
                      blackColor: TroskoColors.lightThemeBlackText,
                    ),
                    overlayColor: context.colors.buttonBackground,
                    disabledBackgroundColor: context.colors.disabledBackground,
                    disabledForegroundColor: context.colors.disabledText,
                  ),
                  child: Text(
                    'settingsLogout'.tr().toUpperCase(),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          ///
          /// LOGOUT TEXT
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsLogoutText'.tr(),
                style: context.textStyles.homeTransactionNote,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsLogoutText2'.tr(),
                style: context.textStyles.homeTransactionNote,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          ///
          /// DELETE ACCOUNT BUTTON
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );

                    /// Show [SettingsDeleteAccountModal]
                    final value = await showModalBottomSheet<({String email, String password, bool shouldDelete})>(
                      context: context,
                      backgroundColor: context.colors.scaffoldBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      builder: (context) => SettingsDeleteAccountModal(
                        userEmail: settingsController.firebase.userEmail,
                        key: const ValueKey('delete-account-modal'),
                      ),
                    );

                    /// `email` and `password` exist
                    if ((value?.email.isNotEmpty ?? false) && (value?.password.isNotEmpty ?? false) && (value?.shouldDelete ?? false)) {
                      /// Delete `user`
                      final isDeletedUser = await settingsController.deleteUser(
                        email: value!.email,
                        password: value.password,
                      );

                      /// User successfully deleted
                      if (isDeletedUser) {
                        /// Go to [LoginScreen]
                        openLogin(context);
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.delete,
                    foregroundColor: getWhiteOrBlackColor(
                      backgroundColor: context.colors.delete,
                      whiteColor: TroskoColors.lightThemeWhiteBackground,
                      blackColor: TroskoColors.lightThemeBlackText,
                    ),
                    overlayColor: context.colors.buttonBackground,
                    disabledBackgroundColor: context.colors.disabledBackground,
                    disabledForegroundColor: context.colors.disabledText,
                  ),
                  child: Text(
                    'settingsDeleteAccount'.tr().toUpperCase(),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          ///
          /// DELETE ACCOUNT TEXT
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsDeleteAccountText'.tr(),
                style: context.textStyles.homeTransactionNote,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'settingsDeleteAccountText2'.tr(),
                style: context.textStyles.homeTransactionNote,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 28),
          ),

          ///
          /// APP INFO
          ///
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPress: playWelcomeToTrosko,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.text,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        TroskoIcons.iconDark,
                        color: context.colors.text,
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Troško',
                      style: context.textStyles.categoryIcon,
                    ),
                    FutureBuilder(
                      future: getAppVersion(),
                      builder: (_, snapshot) {
                        final version = snapshot.data;

                        if (version != null) {
                          return Text(
                            'v$version',
                            style: context.textStyles.categoryName,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 48),
          ),
        ],
      ),
    );
  }
}
