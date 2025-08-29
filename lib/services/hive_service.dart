import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../hive_registrar.g.dart';
import '../models/category/category.dart';
import '../models/transaction/transaction.dart';
import '../util/path.dart';
import 'logger_service.dart';

class HiveService extends ValueNotifier<({List<Transaction> transactions, List<Category> categories})> implements Disposable {
  final LoggerService logger;

  HiveService({
    required this.logger,
  }) : super((transactions: [], categories: []));

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
      ..registerAdapters()
      ..registerAdapter(
        ColorAdapter(),
      );

    transactions = await Hive.openBox<Transaction>('transactionsBox');
    categories = await Hive.openBox<Category>('categoriesBox');

    updateState();
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

  /// Updates `state`
  void updateState() => value = (
    transactions: getTransactions(),
    categories: getCategories(),
  );

  /// Called to get `transactions` from [Hive]
  List<Transaction> getTransactions() => transactions.values.toList();

  /// Called to get `categories` from [Hive]
  List<Category> getCategories() => categories.values.toList();

  /// Stores a new `transaction` in [Hive]
  Future<void> writeTransaction({required Transaction newTransaction}) async {
    await transactions.add(newTransaction);
    updateState();
  }

  /// Stores a new `category` in [Hive]
  Future<void> writeCategory({required Category newCategory}) async {
    await categories.add(newCategory);
    updateState();
  }

  /// Deletes a `transaction` in [Hive]
  Future<void> deleteTransaction({required Transaction transaction}) async {
    final i = getTransactions().indexWhere((t) => t.id == transaction.id);

    if (i == -1) {
      return;
    }

    final key = transactions.keyAt(i);
    await transactions.delete(key);
    updateState();
  }

  /// Deletes a `category` in [Hive]
  Future<void> deleteCategory({required Category category}) async {
    final i = getCategories().indexWhere((c) => c.id == category.id);

    if (i == -1) {
      return;
    }

    final key = categories.keyAt(i);
    await categories.delete(key);
    updateState();
  }

  /// Updates a `transaction` in [Hive]
  Future<void> updateTransaction({required Transaction newTransaction}) async {
    final i = getTransactions().indexWhere((t) => t.id == newTransaction.id);

    if (i == -1) {
      return;
    }

    final key = transactions.keyAt(i);
    await transactions.put(key, newTransaction);
    updateState();
  }

  /// Updates a `category` in [Hive]
  Future<void> updateCategory({required Category newCategory}) async {
    final i = getCategories().indexWhere((c) => c.id == newCategory.id);

    if (i == -1) {
      return;
    }

    final key = categories.keyAt(i);
    await categories.put(key, newCategory);
    updateState();
  }
}
