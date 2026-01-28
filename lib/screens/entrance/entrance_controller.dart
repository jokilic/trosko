import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class EntranceController extends ValueNotifier<({bool googleIsLoading, bool appleIsLoading})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final FirebaseService firebase;
  final HiveService hive;

  EntranceController({
    required this.logger,
    required this.firebase,
    required this.hive,
  }) : super((
         googleIsLoading: false,
         appleIsLoading: false,
       ));

  ///
  /// METHODS
  ///

  /// Triggered when the user presses Google login button
  Future<({User? user, String? error})> googleSignInPressed() async {
    if (value.appleIsLoading) {
      return (
        user: null,
        error: 'entranceWaitAppleToFinish'.tr(),
      );
    }

    updateState(
      googleIsLoading: true,
    );

    try {
      final loginResult = await firebase.signInWithGoogle();

      /// Successful login
      if (loginResult.user != null && loginResult.error == null) {
        /// Store `isLoggedIn` into [Hive]
        await hive.writeSettings(
          hive.getSettings().copyWith(
            isLoggedIn: true,
          ),
        );

        /// Fetch all data from [Firebase] & store into [Hive]
        await getFirebaseDataIntoHive();

        updateState(
          googleIsLoading: false,
        );
      }
      /// Not successful login
      else {
        logger.e('EntranceController -> googleSignInPressed() -> user == null');
        updateState(
          googleIsLoading: false,
        );
      }

      return loginResult;
    } catch (e) {
      logger.e('EntranceController -> googleSignInPressed() -> $e');
      updateState(
        googleIsLoading: false,
      );
      return (user: null, error: '$e');
    }
  }

  /// Triggered when the user presses Apple login button
  Future<({User? user, String? error})> appleSignInPressed() async {
    if (value.googleIsLoading) {
      return (
        user: null,
        error: 'entranceWaitGoogleToFinish'.tr(),
      );
    }

    updateState(
      appleIsLoading: true,
    );

    try {
      final loginResult = await firebase.signInWithApple();

      /// Successful login
      if (loginResult.user != null && loginResult.error == null) {
        /// Store `isLoggedIn` into [Hive]
        await hive.writeSettings(
          hive.getSettings().copyWith(
            isLoggedIn: true,
          ),
        );

        /// Fetch all data from [Firebase] & store into [Hive]
        await getFirebaseDataIntoHive();

        updateState(
          appleIsLoading: false,
        );
      }
      /// Not successful login
      else {
        logger.e('EntranceController -> appleSignInPressed() -> user == null');
        updateState(
          appleIsLoading: false,
        );
      }

      return loginResult;
    } catch (e) {
      logger.e('EntranceController -> appleSignInPressed() -> $e');
      updateState(
        appleIsLoading: false,
      );
      return (user: null, error: '$e');
    }
  }

  /// Gets all data from [Firebase] and stores into [Hive]
  Future<void> getFirebaseDataIntoHive() async {
    final username = await firebase.getUsername();
    final transactions = await firebase.getTransactions();
    final categories = await firebase.getCategories();
    final locations = await firebase.getLocations();

    await hive.storeDataFromFirebase(
      username: username,
      transactions: transactions ?? [],
      categories: categories ?? [],
      locations: locations ?? [],
    );
  }

  /// Updates `state`
  void updateState({
    bool? googleIsLoading,
    bool? appleIsLoading,
  }) => value = (
    googleIsLoading: googleIsLoading ?? value.googleIsLoading,
    appleIsLoading: appleIsLoading ?? value.appleIsLoading,
  );
}
