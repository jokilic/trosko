import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/icons.dart';
import '../../routing.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/extensions.dart';
import '../../util/dependencies.dart';
import '../../util/icons.dart';
import '../../util/snackbars.dart';
import '../../widgets/trosko_app_bar.dart';
import 'entrance_controller.dart';

class EntranceScreen extends WatchingStatefulWidget {
  const EntranceScreen({
    required super.key,
  });

  @override
  State<EntranceScreen> createState() => _EntranceScreenState();
}

class _EntranceScreenState extends State<EntranceScreen> {
  Future<void> handleLogin({
    required BuildContext context,
    required Future<({User? user, String? error})> Function() onLoginPressed,
    required bool useColorfulIcons,
  }) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    unawaited(
      HapticFeedback.lightImpact(),
    );

    final loginResult = await onLoginPressed();

    /// Successful login
    if (loginResult.user != null && loginResult.error == null) {
      openHome(context);
      return;
    }

    /// Non-successful login
    showSnackbar(
      context,
      text: loginResult.error ?? 'errorUnknown'.tr(),
      icon: getPhosphorIcon(
        PhosphorIcons.warningCircle,
        isDuotone: useColorfulIcons,
        isBold: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<EntranceController>(
      () => EntranceController(
        logger: getIt.get<LoggerService>(),
        firebase: getIt.get<FirebaseService>(),
        hive: getIt.get<HiveService>(),
      ),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<EntranceController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entranceController = getIt.get<EntranceController>();

    final state = watchIt<EntranceController>().value;

    final useColorfulIcons = watchIt<HiveService>().value.settings?.useColorfulIcons ?? false;

    final googleIsLoading = state.googleIsLoading;
    final appleIsLoading = state.appleIsLoading;

    return Scaffold(
      body: AutofillGroup(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          slivers: [
            ///
            /// APP BAR
            ///
            TroskoAppBar(
              smallTitle: 'welcomeTitle'.tr(),
              bigTitle: 'welcomeTitle'.tr(),
              bigSubtitle: 'entranceChooseYourSignInMethod'.tr(),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 12),
            ),

            ///
            /// ILLUSTRATION
            ///
            SliverToBoxAdapter(
              child: Image.asset(
                TroskoIcons.illustration,
                height: 256,
                fit: BoxFit.scaleDown,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 56),
            ),

            ///
            /// EMAIL SIGN IN
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => openLogin(context),
                    icon: PhosphorIcon(
                      getPhosphorIcon(
                        PhosphorIcons.identificationCard,
                        isDuotone: useColorfulIcons,
                        isBold: true,
                      ),
                      color: context.colors.text,
                      duotoneSecondaryColor: context.colors.buttonPrimary,
                      size: 24,
                    ),
                    label: Text(
                      'continueWithEmail'.tr(),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: context.textStyles.homeTitleBold,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: context.colors.listTileBackground,
                      foregroundColor: context.colors.text,
                      side: BorderSide(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            ///
            /// GOOGLE SIGN IN
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: googleIsLoading
                        ? null
                        : () => handleLogin(
                            context: context,
                            onLoginPressed: entranceController.googleSignInPressed,
                            useColorfulIcons: useColorfulIcons,
                          ),
                    icon: PhosphorIcon(
                      getPhosphorIcon(
                        PhosphorIcons.googleLogo,
                        isDuotone: useColorfulIcons,
                        isBold: true,
                      ),
                      color: context.colors.text,
                      duotoneSecondaryColor: context.colors.buttonPrimary,
                      size: 24,
                    ),
                    label: Text(
                      'continueWithGoogle'.tr(),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: context.textStyles.homeTitleBold,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: context.colors.listTileBackground,
                      foregroundColor: context.colors.text,
                      disabledBackgroundColor: context.colors.listTileBackground,
                      disabledForegroundColor: context.colors.text,
                      side: BorderSide(
                        color: googleIsLoading ? context.colors.listTileBackground : context.colors.text,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            ///
            /// APPLE SIGN IN
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: appleIsLoading
                        ? null
                        : () => handleLogin(
                            context: context,
                            onLoginPressed: entranceController.appleSignInPressed,
                            useColorfulIcons: useColorfulIcons,
                          ),
                    icon: PhosphorIcon(
                      getPhosphorIcon(
                        PhosphorIcons.appleLogo,
                        isDuotone: useColorfulIcons,
                        isBold: true,
                      ),
                      color: context.colors.text,
                      duotoneSecondaryColor: context.colors.buttonPrimary,
                      size: 24,
                    ),
                    label: Text(
                      'continueWithApple'.tr(),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: context.textStyles.homeTitleBold,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: context.colors.listTileBackground,
                      foregroundColor: context.colors.text,
                      disabledBackgroundColor: context.colors.listTileBackground,
                      disabledForegroundColor: context.colors.text,
                      side: BorderSide(
                        color: appleIsLoading ? context.colors.listTileBackground : context.colors.text,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            ///
            /// BOTTOM SPACING
            ///
            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }
}
