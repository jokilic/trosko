import 'package:flutter/material.dart';

import '../models/category/category.dart';
import '../models/transaction/transaction.dart';
import 'firebase_service.dart';
import 'hive_service.dart';
import 'logger_service.dart';

class StorageService extends ValueNotifier<({String? username, List<Transaction> transactions, List<Category> categories})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseService firebase;

  StorageService({
    required this.logger,
    required this.hive,
    required this.firebase,
  }) : super((username: '', transactions: [], categories: []));
}
