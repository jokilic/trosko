import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../util/email.dart';

class RegisterController extends ValueNotifier<({bool emailValid, bool passwordValid, bool isLoading})> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final FirebaseService firebase;
  final HiveService hive;

  RegisterController({
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

  /// Triggered when the user presses register button
  Future<({User? user, String? error})> registerPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();

    updateState(
      isLoading: true,
    );

    try {
      /// Register into [Firebase]
      final registerResult = await registerUser();

      /// Successful register
      if (registerResult.user != null && registerResult.error == null) {
        /// Store `isLoggedIn` into [Hive]
        // await hive.writeSettings(
        //   hive.getSettings().copyWith(
        //     isLoggedIn: true,
        //   ),
        // );

        /// Check if user has written a `name`
        final name = nameTextEditingController.text.trim();

        /// name exists, store in [Hive] and [Firebase]
        if (name.isNotEmpty) {
          // await hive.writeUsername(name);

          await firebase.writeUsername(
            newUsername: name,
          );
        }

        /// Fetch all data from [Firebase] & store into [Hive]
        await getFirebaseDataIntoHive();

        updateState(
          isLoading: false,
        );
      }
      /// Not successful register
      else {
        logger.e('RegisterController -> registerPressed() -> user == null');
        updateState(
          isLoading: false,
        );
      }

      return registerResult;
    } catch (e) {
      logger.e('RegisterController -> registerPressed() -> $e');
      updateState(
        isLoading: false,
      );
      return (user: null, error: '$e');
    }
  }

  /// Registers user into [Firebase]
  Future<({User? user, String? error})> registerUser() async {
    /// Parse values
    final email = emailTextEditingController.text.trim();
    final password = passwordTextEditingController.text.trim();

    return firebase.registerUser(
      email: email,
      password: password,
    );
  }

  /// Gets all data from [Firebase] and stores into [Hive]
  Future<void> getFirebaseDataIntoHive() async {
    final username = await firebase.getUsername();
    final transactions = await firebase.getTransactions();
    final categories = await firebase.getCategories();

    // await hive.storeDataFromFirebase(
    //   username: username,
    //   transactions: transactions ?? [],
    //   categories: categories ?? [],
    // );
  }

  /// Triggered on every [TextField] change
  /// Validates email & password
  /// Updates register button state
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
