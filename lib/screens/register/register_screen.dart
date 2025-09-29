import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../constants/icons.dart';
import '../../routing.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
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
      body: CustomScrollView(
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
                autofocus: false,
                controller: registerController.emailTextEditingController,
                labelText: 'email'.tr(),
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
                obscureText: true,
                autofocus: false,
                controller: registerController.passwordTextEditingController,
                labelText: 'password'.tr(),
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
                autofocus: false,
                controller: registerController.nameTextEditingController,
                labelText: 'name'.tr(),
                keyboardType: TextInputType.name,
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: AnimatedSwitcher(
          duration: TroskoDurations.loginAnimation,
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
                        ? () async {
                            unawaited(
                              HapticFeedback.lightImpact(),
                            );

                            final isRegisterSuccessful = await registerController.registerPressed();

                            if (isRegisterSuccessful) {
                              openHome(context);
                            }
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        28,
                        24,
                        MediaQuery.paddingOf(context).bottom + 12,
                      ),
                      backgroundColor: context.colors.buttonPrimary,
                      foregroundColor: context.colors.text,
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
