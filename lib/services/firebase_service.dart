import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/category/category.dart';
import '../models/transaction/transaction.dart';
import 'logger_service.dart';

class FirebaseService extends ValueNotifier<({String? username, List<Transaction> transactions, List<Category> categories})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseService({
    required this.logger,
    required this.auth,
    required this.firestore,
  }) : super((username: '', transactions: [], categories: []));

  ///
  /// INIT
  ///

  Future<void> init() async {
    await updateState();
  }

  ///
  /// METHODS
  ///

  /// Updates `state` from [Firebase]
  Future<void> updateState() async {
    final user = auth.currentUser;

    if (user == null) {
      return;
    }

    final username = await getUsername();
    final transactions = await getTransactions() ?? [];
    final categories = await getCategories() ?? [];

    value = (
      username: username,
      transactions: transactions,
      categories: categories,
    );
  }

  /// Logs user into [Firebase]
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return user.user;
    } catch (e) {
      logger.e('FirebaseService -> loginUser() -> $e');
      return null;
    }
  }

  /// Logs user out of [Firebase]
  void logOut() => auth.signOut();

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

      query = query.orderBy('createdAt', descending: true);

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
  Future<bool> deleteCategory({required Category category}) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final collection = firestore.collection('users').doc(user.uid).collection('categories');

      await collection.doc(category.id).delete();

      return true;
    } catch (e) {
      logger.e('FirebaseService -> deleteCategory() -> $e');
      return false;
    }
  }
}
