import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';

import '../../routing.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import '../../widgets/trosko_app_bar.dart';
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

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          ///
          /// APP BAR
          ///
          const TroskoAppBar(
            smallTitle: 'Welcome to Troško',
            bigTitle: 'Welcome to Troško',
            bigSubtitle: 'Enter your credentials',
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          ///
          /// EMAIL TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Email',
                style: context.textStyles.homeTitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
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
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.left,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          ///
          /// PASSWORD TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Password',
                style: context.textStyles.homeTitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
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
                labelText: 'Password',
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.left,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          ///
          /// NAME TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Name',
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
                autofocus: false,
                controller: loginController.nameTextEditingController,
                labelText: 'Name',
                keyboardType: TextInputType.name,
                textAlign: TextAlign.left,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.go,
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
      bottomNavigationBar: SizedBox(
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
            backgroundColor: context.colors.text,
            foregroundColor: context.colors.listTileBackground,
            overlayColor: context.colors.buttonBackground,
            disabledBackgroundColor: context.colors.disabledBackground,
            disabledForegroundColor: context.colors.disabledText,
          ),
          child: Text(
            'Login'.toUpperCase(),
          ),
        ),
      ),
    );
  }
}
