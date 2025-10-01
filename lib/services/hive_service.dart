import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../models/category/category.dart';
import '../models/settings/settings.dart';
import '../models/transaction/transaction.dart';
import '../theme/colors.dart';
import '../util/path.dart';
import 'logger_service.dart';

class HiveService extends ValueNotifier<({Settings? settings, String? username, List<Transaction> transactions, List<Category> categories})> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  HiveService({
    required this.logger,
  }) : super((settings: null, username: '', transactions: [], categories: []));

  ///
  /// VARIABLES
  ///

  late final Box<Settings> settings;
  late final Box<String> username;
  late final Box<Transaction> transactions;
  late final Box<Category> categories;

  final defaultSettings = Settings(
    isLoggedIn: false,
    themeModeInt: 0,
    primaryColor: TroskoColors.green,
  );

  ///
  /// INIT
  ///

  Future<void> init() async {
    final directory = await getHiveDirectory();

    Hive.init(directory?.path);

    if (!Hive.isAdapterRegistered(ColorAdapter().typeId)) {
      Hive.registerAdapter(ColorAdapter());
    }
    if (!Hive.isAdapterRegistered(SettingsAdapter().typeId)) {
      Hive.registerAdapter(SettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(CategoryAdapter().typeId)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(TransactionAdapter().typeId)) {
      Hive.registerAdapter(TransactionAdapter());
    }

    settings = await Hive.openBox<Settings>('settingsBox');
    username = await Hive.openBox<String>('usernameBox');
    transactions = await Hive.openBox<Transaction>('transactionsBox');
    categories = await Hive.openBox<Category>('categoriesBox');

    updateState();
  }

  ///
  /// DISPOSE
  ///

  @override
  Future<void> onDispose() async {
    await settings.close();
    await username.close();
    await transactions.close();
    await categories.close();
    await Hive.close();
  }

  ///
  /// METHODS
  ///

  /// Stores all data into [Hive]
  Future<void> storeDataFromFirebase({
    required String? username,
    required List<Transaction> transactions,
    required List<Category> categories,
  }) async {
    if (username?.isNotEmpty ?? false) {
      await writeUsername(username!);
    }
    await writeListTransactions(transactions);
    await writeListCategories(categories);

    updateState();
  }

  /// Clears everything from [Hive]
  Future<void> clearEverything() async {
    await settings.clear();
    await username.clear();
    await transactions.clear();
    await categories.clear();
  }

  /// Updates `state`
  void updateState() => value = (
    username: getUsername(),
    transactions: getTransactions(),
    categories: getCategories(),
    settings: getSettings(),
  );

  /// Called to get `settings` from [Hive]
  Settings getSettings() => settings.values.toList().firstOrNull ?? defaultSettings;

  /// Called to get `username` from [Hive]
  String? getUsername() => username.values.toList().firstOrNull;

  /// Called to get `transactions` from [Hive]
  List<Transaction> getTransactions() => transactions.values.toList();

  /// Called to get `categories` from [Hive]
  List<Category> getCategories() => categories.values.toList();

  /// Stores new `settings` in [Hive]
  Future<void> writeSettings(Settings newSettings) async {
    await settings.clear();
    await settings.add(newSettings);
    updateState();
  }

  /// Stores a new `username` in [Hive]
  Future<void> writeUsername(String newUsername) async {
    await username.clear();
    await username.add(newUsername);
    updateState();
  }

  /// Clears old list and stores a new `List<Transaction>` in [Hive]
  Future<void> writeListTransactions(List<Transaction> newTransactions) async {
    await transactions.clear();
    await transactions.addAll(newTransactions);
  }

  /// Clears old list and stores a new `List<Category>` in [Hive]
  Future<void> writeListCategories(List<Category> newCategories) async {
    await categories.clear();
    await categories.addAll(newCategories);
  }

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
