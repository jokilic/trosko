import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'logger_service.dart';

class FirebaseService {
  final LoggerService logger;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseService({
    required this.logger,
    required this.auth,
    required this.firestore,
  });

  ///
  /// METHODS
  ///

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

  Future<String?> getUsername() async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return null;
      }

      final docSnapshot = await firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['userName'];
      }

      return null;
    } catch (e) {
      logger.e('FirebaseService -> getUserName() -> $e');
      return null;
    }
  }
}
