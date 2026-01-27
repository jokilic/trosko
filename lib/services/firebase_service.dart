import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/category/category.dart';
import '../models/location/location.dart';
import '../models/transaction/transaction.dart';
import 'logger_service.dart';

class FirebaseService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  FirebaseService({
    required this.logger,
    required this.auth,
    required this.firestore,
    required this.googleSignIn,
  });

  ///
  /// GETTERS
  ///

  String? get userEmail => auth.currentUser?.email;

  ///
  /// METHODS
  ///

  /// Logs user into [Firebase]
  Future<({User? user, String? error})> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return (user: user.user, error: null);
    } on FirebaseAuthException catch (e) {
      final error = switch (e.code) {
        'invalid-email' => 'errorEmailInvalid'.tr(),
        'user-disabled' => 'errorAccountDisabled'.tr(),
        'user-not-found' => 'errorUserNotFound'.tr(),
        'wrong-password' => 'errorPasswordWrong'.tr(),
        'invalid-credential' => 'errorInvalidCredential'.tr(),
        'too-many-requests' => 'errorTooManyRequests'.tr(),
        'operation-not-allowed' => 'errorOperationNotAllowed'.tr(),
        _ => e.code,
      };

      logger.e(error);
      return (user: null, error: error);
    } catch (e) {
      final error = 'Login error $e';
      logger.e(error);
      return (user: null, error: error);
    }
  }

  /// Logs user out of [Firebase]
  void logOut() => auth.signOut();

  /// Signs user in with Google and authenticates with [Firebase]
  Future<({User? user, String? error})> signInWithGoogle() async {
    try {
      await googleSignIn.initialize();

      if (!googleSignIn.supportsAuthenticate()) {
        return (user: null, error: 'errorOperationNotAllowed'.tr());
      }

      final user = await googleSignIn.authenticate();
      final googleAuth = user.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        return (user: null, error: 'errorInvalidCredential'.tr());
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);

      return (user: userCredential.user, error: null);
    } on GoogleSignInException catch (e) {
      final error = switch (e.code) {
        GoogleSignInExceptionCode.unknownError => 'errorUnknown'.tr(),
        GoogleSignInExceptionCode.canceled => 'errorGoogleCanceled'.tr(),
        GoogleSignInExceptionCode.interrupted => 'errorGoogleInterrupted'.tr(),
        GoogleSignInExceptionCode.clientConfigurationError => 'errorGoogleClientConfigurationError'.tr(),
        GoogleSignInExceptionCode.providerConfigurationError => 'errorGoogleProviderConfigurationError'.tr(),
        GoogleSignInExceptionCode.uiUnavailable => 'errorGoogleUIUnavailable'.tr(),
        GoogleSignInExceptionCode.userMismatch => 'errorGoogleUserMismatch'.tr(),
      };

      logger.e('GoogleSignInException ${e.code}: ${e.description}');
      return (user: null, error: error);
    } on FirebaseAuthException catch (e) {
      final error = switch (e.code) {
        'account-exists-with-different-credential' => 'errorInvalidCredential'.tr(),
        'invalid-credential' => 'errorInvalidCredential'.tr(),
        'user-disabled' => 'errorAccountDisabled'.tr(),
        'operation-not-allowed' => 'errorOperationNotAllowed'.tr(),
        'too-many-requests' => 'errorTooManyRequests'.tr(),
        _ => e.code,
      };

      logger.e(error);
      return (user: null, error: error);
    } catch (e) {
      final error = 'Google sign-in error $e';
      logger.e(error);
      return (user: null, error: error);
    }
  }

  /// Registers user into [Firebase]
  Future<({User? user, String? error})> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return (user: user.user, error: null);
    } on FirebaseAuthException catch (e) {
      final error = switch (e.code) {
        'email-already-in-use' => 'errorEmailInUse'.tr(),
        'invalid-email' => 'errorEmailInvalid'.tr(),
        'operation-not-allowed' => 'errorOperationNotAllowed'.tr(),
        'weak-password' => 'errorWeakPassword'.tr(),
        'too-many-requests' => 'errorTooManyRequests'.tr(),
        _ => e.code,
      };

      logger.e(error);
      return (user: null, error: error);
    } catch (e) {
      final error = 'Register error $e';
      logger.e(error);
      return (user: null, error: error);
    }
  }

  /// Deletes data and user from [Firebase]
  Future<bool> deleteUser({
    required String email,
    required String password,
  }) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      /// Reauthenticate before deleting
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      /// Get user document reference
      final userDoc = firestore.collection('users').doc(user.uid);

      /// Delete all `Transactions`
      await deleteCollectionPaged(
        userDoc.collection('transactions'),
      );

      /// Delete all `Categories`
      await deleteCollectionPaged(
        userDoc.collection('categories'),
      );

      /// Delete all `Locations`
      await deleteCollectionPaged(
        userDoc.collection('locations'),
      );

      /// Delete `user` document
      await userDoc.delete();

      /// Delete `user`
      await user.delete();
      return true;
    } catch (e) {
      final error = 'FirebaseService -> deleteUser() -> $e';
      logger.e(error);

      return false;
    }
  }

  /// Paged delete for [Firebase] collection
  Future<void> deleteCollectionPaged(
    CollectionReference<Map<String, dynamic>> collection, {
    int batchSize = 300,
  }) async {
    while (true) {
      final snap = await collection.limit(batchSize).get();

      if (snap.docs.isEmpty) {
        break;
      }

      final batch = firestore.batch();

      for (final d in snap.docs) {
        batch.delete(d.reference);
      }

      await batch.commit();
    }
  }

  ///
  /// NAME
  ///

  /// Fetches `username` from [Firebase]
  Future<String?> getUsername() async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return null;
      }

      final docSnapshot = await firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['username'];
      }

      return null;
    } catch (e) {
      logger.e('FirebaseService -> getUsername() -> $e');
      return null;
    }
  }

  /// Adds new `username` into [Firebase]
  Future<bool> writeUsername({required String newUsername}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final docReference = firestore.collection('users').doc(user.uid);

      await docReference.set(
        {'username': newUsername.trim()},
      );

      return true;
    } catch (e) {
      logger.e('FirebaseService -> writeUsername() -> $e');
      return false;
    }
  }

  ///
  /// TRANSACTIONS
  ///

  /// Fetches `Transactions` from [Firebase]
  Future<List<Transaction>?> getTransactions() async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return null;
      }

      Query<Map<String, dynamic>> query = firestore.collection('users').doc(user.uid).collection('transactions');

      query = query.orderBy('createdAt', descending: true);

      final snapshot = await query.get();

      return snapshot.docs.map(Transaction.fromFirestore).toList();
    } catch (e) {
      logger.e('FirebaseService -> getTransactions() -> $e');
      return null;
    }
  }

  /// Adds new `Transaction` into [Firebase]
  Future<bool> writeTransaction({required Transaction newTransaction}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final collection = firestore.collection('users').doc(user.uid).collection('transactions');

      await collection.doc(newTransaction.id).set(newTransaction.toMap());

      return true;
    } catch (e) {
      logger.e('FirebaseService -> writeTransaction() -> $e');
      return false;
    }
  }

  /// Updates `Transaction` in [Firebase]
  Future<bool> updateTransaction({required Transaction newTransaction}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final collection = firestore.collection('users').doc(user.uid).collection('transactions');

      await collection.doc(newTransaction.id).set(newTransaction.toMap());

      return true;
    } catch (e) {
      logger.e('FirebaseService -> updateTransaction() -> $e');
      return false;
    }
  }

  /// Deletes `Transaction` from [Firebase]
  Future<bool> deleteTransaction({required Transaction transaction}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final collection = firestore.collection('users').doc(user.uid).collection('transactions');

      await collection.doc(transaction.id).delete();

      return true;
    } catch (e) {
      logger.e('FirebaseService -> deleteTransaction() -> $e');
      return false;
    }
  }

  ///
  /// CATEGORIES
  ///

  /// Fetches `Categories` from [Firebase]
  Future<List<Category>?> getCategories() async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return null;
      }

      Query<Map<String, dynamic>> query = firestore.collection('users').doc(user.uid).collection('categories');

      query = query.orderBy('createdAt', descending: false);

      final snapshot = await query.get();

      return snapshot.docs.map(Category.fromFirestore).toList();
    } catch (e) {
      logger.e('FirebaseService -> getCategories() -> $e');
      return null;
    }
  }

  /// Adds new `Category` into [Firebase]
  Future<bool> writeCategory({required Category newCategory}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final collection = firestore.collection('users').doc(user.uid).collection('categories');

      await collection.doc(newCategory.id).set(newCategory.toMap());

      return true;
    } catch (e) {
      logger.e('FirebaseService -> writeCategory() -> $e');
      return false;
    }
  }

  /// Updates `Category` in [Firebase]
  Future<bool> updateCategory({required Category newCategory}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final collection = firestore.collection('users').doc(user.uid).collection('categories');

      await collection.doc(newCategory.id).set(newCategory.toMap());

      return true;
    } catch (e) {
      logger.e('FirebaseService -> updateCategory() -> $e');
      return false;
    }
  }

  /// Deletes `Category` from [Firebase]
  Future<void> deleteCategory({required Category category}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('categories').doc(category.id).delete();
    } catch (e) {
      logger.e('FirebaseService -> deleteCategory() -> $e');
    }
  }

  ///
  /// LOCATIONS
  ///

  /// Fetches `Locations` from [Firebase]
  Future<List<Location>?> getLocations() async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return null;
      }

      Query<Map<String, dynamic>> query = firestore.collection('users').doc(user.uid).collection('locations');

      query = query.orderBy('createdAt', descending: false);

      final snapshot = await query.get();

      return snapshot.docs.map(Location.fromFirestore).toList();
    } catch (e) {
      logger.e('FirebaseService -> getLocations() -> $e');
      return null;
    }
  }

  /// Adds new `Location` into [Firebase]
  Future<bool> writeLocation({required Location newLocation}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final collection = firestore.collection('users').doc(user.uid).collection('locations');

      await collection.doc(newLocation.id).set(newLocation.toMap());

      return true;
    } catch (e) {
      logger.e('FirebaseService -> writeLocation() -> $e');
      return false;
    }
  }

  /// Updates `Location` in [Firebase]
  Future<bool> updateLocation({required Location newLocation}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final collection = firestore.collection('users').doc(user.uid).collection('locations');

      await collection.doc(newLocation.id).set(newLocation.toMap());

      return true;
    } catch (e) {
      logger.e('FirebaseService -> updateLocation() -> $e');
      return false;
    }
  }

  /// Deletes `Location` from [Firebase]
  Future<bool> deleteLocation({required Location location}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final collection = firestore.collection('users').doc(user.uid).collection('locations');

      await collection.doc(location.id).delete();

      return true;
    } catch (e) {
      logger.e('FirebaseService -> deleteLocation() -> $e');
      return false;
    }
  }
}
