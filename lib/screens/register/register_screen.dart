import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../constants/icons.dart';
import '../../routing.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/color.dart';
import '../../util/dependencies.dart';
import '../../util/snackbars.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_loading.dart';
import '../../widgets/trosko_text_field.dart';
import 'register_controller.dart';

class RegisterScreen extends WatchingStatefulWidget {
  const RegisterScreen({
    required super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Future<void> handleRegister({
    required BuildContext context,
    required Future<({User? user, String? error})> Function() onRegisterPressed,
  }) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    unawaited(
      HapticFeedback.lightImpact(),
    );

    final registerResult = await onRegisterPressed();

    /// Successful register
    if (registerResult.user != null && registerResult.error == null) {
      openHome(context);
      return;
    }

    /// Non-successful register
    showSnackbar(
      context,
      text: registerResult.error ?? 'errorUnknown'.tr(),
      icon: PhosphorIcons.warningCircle(
        PhosphorIconsStyle.bold,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<RegisterController>(
      () => RegisterController(
        logger: getIt.get<LoggerService>(),
        firebase: getIt.get<FirebaseService>(),
        hive: getIt.get<HiveService>(),
      ),
      afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<RegisterController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerController = getIt.get<RegisterController>();

    final state = watchIt<RegisterController>().value;

    final validated = state.emailValid && state.passwordValid;
    final isLoading = state.isLoading;

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
              bigSubtitle: 'welcomeSubtitle'.tr(),
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
              child: SizedBox(height: 40),
            ),

            ///
            /// EMAIL
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: TroskoTextField(
                  autocorrect: false,
                  controller: registerController.emailTextEditingController,
                  labelText: 'email'.tr(),
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.left,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            ///
            /// PASSWORD
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: TroskoTextField(
                  autocorrect: false,
                  obscureText: true,
                  controller: registerController.passwordTextEditingController,
                  labelText: 'password'.tr(),
                  autofillHints: const [AutofillHints.password],
                  keyboardType: TextInputType.visiblePassword,
                  textAlign: TextAlign.left,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            ///
            /// NAME
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: TroskoTextField(
                  controller: registerController.nameTextEditingController,
                  labelText: 'name'.tr(),
                  autofillHints: const [AutofillHints.name],
                  keyboardType: TextInputType.name,
                  onSubmitted: (_) {
                    if (!validated || isLoading) {
                      return;
                    }

                    unawaited(
                      handleRegister(
                        context: context,
                        onRegisterPressed: registerController.registerPressed,
                      ),
                    );
                  },
                  textAlign: TextAlign.left,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.go,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            ///
            /// LOGIN
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Text.rich(
                  TextSpan(
                    text: 'registerLogin'.tr(),
                    children: [
                      TextSpan(
                        text: 'clickHere'.tr(),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            HapticFeedback.lightImpact();
                            openLogin(context);
                          },
                        style: context.textStyles.homeTitleBold,
                      ),
                    ],
                  ),
                  style: context.textStyles.homeTitle,
                  textAlign: TextAlign.center,
                ),
              ),
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: AnimatedSwitcher(
          duration: TroskoDurations.switchAnimation,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeIn,
          child: isLoading
              ? Container(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    28,
                    24,
                    MediaQuery.paddingOf(context).bottom + 12,
                  ),
                  child: TroskoLoading(
                    color: context.colors.text,
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: validated
                        ? () => handleRegister(
                            context: context,
                            onRegisterPressed: registerController.registerPressed,
                          )
                        : null,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        28,
                        24,
                        MediaQuery.paddingOf(context).bottom + 12,
                      ),
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
                      'registerButton'.tr().toUpperCase(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
