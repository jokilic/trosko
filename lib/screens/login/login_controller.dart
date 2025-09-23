import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../util/email.dart';

class LoginController extends ValueNotifier<({bool emailValid, bool passwordValid, bool isLoading})> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final FirebaseService firebase;
  final HiveService hive;

  LoginController({
    required this.logger,
    required this.firebase,
    required this.hive,
  }) : super((
         emailValid: false,
         passwordValid: false,
         isLoading: false,
       ));

  ///
  /// VARIABLES
  ///

  late final emailTextEditingController = TextEditingController();
  late final passwordTextEditingController = TextEditingController();
  late final nameTextEditingController = TextEditingController();

  ///
  /// INIT
  ///

  void init() {
    /// Validation
    emailTextEditingController.addListener(
      validateEmailAndPassword,
    );

    /// Validation
    passwordTextEditingController.addListener(
      validateEmailAndPassword,
    );
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    nameTextEditingController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Triggered when the user presses login button
  Future<bool> loginPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();

    updateState(
      isLoading: true,
    );

    try {
      /// Login into [Firebase]
      final user = await loginUser();

      /// Successful login
      if (user != null) {
        /// Store `isLoggedIn` into [Hive]
        await hive.writeIsLoggedIn(true);

        /// Store `name` into [Firebase] if exists
        await storeUsername();

        /// Fetch all data from [Firebase] & store into [Hive]
        await getFirebaseDataIntoHive();

        updateState(
          isLoading: false,
        );

        return true;
      }

      logger.e('LoginController -> loginPressed() -> user == null');
      updateState(
        isLoading: false,
      );
      return false;
    } catch (e) {
      logger.e('LoginController -> loginPressed() -> $e');
      updateState(
        isLoading: false,
      );
      return false;
    }
  }

  /// Logs user into [Firebase]
  Future<User?> loginUser() async {
    /// Parse values
    final email = emailTextEditingController.text.trim();
    final password = passwordTextEditingController.text.trim();

    return firebase.loginUser(
      email: email,
      password: password,
    );
  }

  /// Stores new name into [Firebase]
  Future<void> storeUsername() async {
    /// Parse value
    final username = nameTextEditingController.text.trim();

    if (username.isNotEmpty) {
      await firebase.writeUsername(
        newUsername: username,
      );
    }
  }

  /// Gets all data from [Firebase] and stores into [Hive]
  Future<void> getFirebaseDataIntoHive() async {
    final username = await firebase.getUsername();
    final transactions = await firebase.getTransactions();
    final categories = await firebase.getCategories();

    await hive.storeDataFromFirebase(
      username: username,
      transactions: transactions ?? [],
      categories: categories ?? [],
    );
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
    bool? isLoading,
  }) => value = (
    emailValid: emailValid ?? value.emailValid,
    passwordValid: passwordValid ?? value.passwordValid,
    isLoading: isLoading ?? value.isLoading,
  );
}
