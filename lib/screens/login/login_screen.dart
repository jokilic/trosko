import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../routing.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_loading.dart';
import '../../widgets/trosko_text_field.dart';
import 'login_controller.dart';

class LoginScreen extends WatchingStatefulWidget {
  const LoginScreen({
    required super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<LoginController>(
      () => LoginController(
        logger: getIt.get<LoggerService>(),
        firebase: getIt.get<FirebaseService>(),
        hive: getIt.get<HiveService>(),
      ),
      afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<LoginController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginController = getIt.get<LoginController>();

    final state = watchIt<LoginController>().value;

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
            smallTitle: 'loginTitle'.tr(),
            bigTitle: 'loginTitle'.tr(),
            bigSubtitle: 'loginSubtitle'.tr(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          ///
          /// EMAIL
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: TroskoTextField(
                autofocus: false,
                controller: loginController.emailTextEditingController,
                labelText: 'loginEmail'.tr(),
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
                controller: loginController.passwordTextEditingController,
                labelText: 'loginPassword'.tr(),
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.left,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.go,
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
      bottomNavigationBar: AnimatedSwitcher(
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

                          final isLoginSuccessful = await loginController.loginPressed();

                          if (isLoginSuccessful) {
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
                    'loginButton'.tr().toUpperCase(),
                  ),
                ),
              ),
      ),
    );
  }
}
