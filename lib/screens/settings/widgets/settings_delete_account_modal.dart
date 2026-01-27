import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';
import '../../../util/email.dart';
import '../../../widgets/trosko_text_field.dart';

class SettingsDeleteAccountModal extends StatefulWidget {
  final String? userEmail;

  const SettingsDeleteAccountModal({
    required this.userEmail,
    required super.key,
  });

  @override
  State<SettingsDeleteAccountModal> createState() => _SettingsDeleteAccountModalState();
}

class _SettingsDeleteAccountModalState extends State<SettingsDeleteAccountModal> {
  var isEmailValid = false;
  var isPasswordValid = false;

  late final emailTextEditingController = TextEditingController();
  late final passwordTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Validation
    emailTextEditingController.addListener(
      validateEmailAndPassword,
    );

    /// Validation
    passwordTextEditingController.addListener(
      validateEmailAndPassword,
    );
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();

    super.dispose();
  }

  /// Triggered on every [TextField] change
  /// Validates email & password
  /// Updates login button state
  void validateEmailAndPassword() {
    /// Parse values
    final email = emailTextEditingController.text.trim();
    final password = passwordTextEditingController.text.trim();

    /// Validate values
    updateState(
      emailValid: isValidEmail(email),
      passwordValid: password.length >= 8,
    );
  }

  /// Updates `state`
  void updateState({
    bool? emailValid,
    bool? passwordValid,
  }) => setState(() {
    isEmailValid = emailValid ?? isEmailValid;
    isPasswordValid = passwordValid ?? isPasswordValid;
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          /// TEXT
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              'settingsDeleteAccountModalText'.tr(),
              style: context.textStyles.homeTitle,
            ),
          ),
          const SizedBox(height: 12),

          ///
          /// EMAIL
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TroskoTextField(
              controller: emailTextEditingController,
              labelText: 'email'.tr(),
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(height: 16),

          ///
          /// PASSWORD
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TroskoTextField(
              obscureText: true,
              controller: passwordTextEditingController,
              labelText: 'password'.tr(),
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.go,
            ),
          ),
          const SizedBox(height: 28),

          ///
          /// BUTTON
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isEmailValid && isPasswordValid
                    ? () {
                        HapticFeedback.lightImpact();

                        /// Parse values
                        final email = emailTextEditingController.text.trim();
                        final password = passwordTextEditingController.text.trim();

                        Navigator.of(context).pop(
                          (
                            email: email,
                            password: password,
                            shouldDelete: widget.userEmail == email,
                          ),
                        );
                      }
                    : null,
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
        ],
      ),
    ),
  );
}
