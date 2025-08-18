import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../hive_registrar.g.dart';
import '../models/category/category.dart';
import '../models/transaction/transaction.dart';
import '../util/path.dart';
import 'logger_service.dart';

class HiveService implements Disposable {
  final LoggerService logger;

  HiveService({
    required this.logger,
  });

  ///
  /// VARIABLES
  ///

  late final Box<Transaction> transactions;
  late final Box<Category> categories;

  ///
  /// INIT
  ///

  Future<void> init() async {
    final directory = await getHiveDirectory();

    Hive
      ..init(directory?.path)
      ..registerAdapters();

    transactions = await Hive.openBox<Transaction>('transactionsBox');
    categories = await Hive.openBox<Category>('categoriesBox');
  }

  ///
  /// DISPOSE
  ///

  @override
  Future<void> onDispose() async {
    await transactions.close();
    await categories.close();
    await Hive.close();
  }

  ///
  /// METHODS
  ///

  /// Called to get `transactions` from [Hive]
  List<Transaction> getTransactions() => transactions.values.toList();

  /// Called to get `categories` from [Hive]
  List<Category> getCategories() => categories.values.toList();

  /// Stores a new `transaction` in [Hive]
  void writeTransaction({required Transaction newTransaction}) => transactions.add(newTransaction);

  /// Stores a new `category` in [Hive]
  void writeCategory({required Category newCategory}) => categories.add(newCategory);

  /// Deletes a `transaction` in [Hive]
  void deleteTransaction({required Transaction transaction}) {
    final i = getTransactions().indexWhere((t) => t.id == transaction.id);

    if (i == -1) {
      return;
    }

    final key = transactions.keyAt(i);
    transactions.delete(key);
  }

  /// Deletes a `category` in [Hive]
  void deleteCategory({required Category category}) {
    final i = getCategories().indexWhere((c) => c.id == category.id);

    if (i == -1) {
      return;
    }

    final key = categories.keyAt(i);
    categories.delete(key);
  }

  /// Updates a `transaction` in [Hive]
  void updateTransaction({required Transaction newTransaction}) {
    final i = getCategories().indexWhere((t) => t.id == newTransaction.id);

    if (i == -1) {
      return;
    }

    final key = transactions.keyAt(i);
    transactions.put(key, newTransaction);
  }

  /// Updates a `category` in [Hive]
  void updateCategory({required Category newCategory}) {
    final i = getCategories().indexWhere((c) => c.id == newCategory.id);

    if (i == -1) {
      return;
    }

    final key = categories.keyAt(i);
    categories.put(key, newCategory);
  }
}
