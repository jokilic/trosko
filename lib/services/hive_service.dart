import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/category/category.dart';
import '../models/hive_registrar.g.dart';
import '../models/location/location.dart';
import '../models/settings/settings.dart';
import '../models/transaction/transaction.dart';
import '../theme/colors.dart';
import '../util/path.dart';
import 'logger_service.dart';

class HiveService extends ValueNotifier<({Settings? settings, String? username, List<Transaction> transactions, List<Category> categories, List<Location> locations})>
    implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  HiveService({
    required this.logger,
  }) : super(
         (
           settings: null,
           username: '',
           transactions: [],
           categories: [],
           locations: [],
         ),
       );

  ///
  /// VARIABLES
  ///

  late final Box<Settings> settings;
  late final Box<String> username;

  late final Box<bool> expandedCategories;
  late final Box<bool> expandedLocations;

  late final Box<Transaction> transactions;
  late final Box<Category> categories;
  late final Box<Location> locations;

  final defaultSettings = Settings(
    isLoggedIn: false,
    troskoThemeId: null,
    primaryColor: TroskoColors.green,
    useNotificationListener: false,
    useVectorMaps: true,
  );

  ///
  /// INIT
  ///

  Future<void> init() async {
    final directory = await getHiveDirectory();

    Hive
      ..init(directory?.path)
      ..registerAdapters();

    settings = await Hive.openBox<Settings>('settingsBox');
    username = await Hive.openBox<String>('usernameBox');

    expandedCategories = await Hive.openBox<bool>('expandedCategoriesBox');
    expandedLocations = await Hive.openBox<bool>('expandedLocationsBox');

    transactions = await Hive.openBox<Transaction>('transactionsBox');
    categories = await Hive.openBox<Category>('categoriesBox');
    locations = await Hive.openBox<Location>('locationsBox');

    updateState();
  }

  ///
  /// DISPOSE
  ///

  @override
  Future<void> onDispose() async {
    await settings.close();
    await username.close();

    await expandedCategories.close();
    await expandedLocations.close();

    await transactions.close();
    await categories.close();
    await locations.close();

    await Hive.close();
  }

  ///
  /// METHODS
  ///

  /// Stores all data into [Hive]
  Future<void> storeDataFromFirebase({
    required String? username,
    required List<Transaction>? transactions,
    required List<Category>? categories,
    required List<Location>? locations,
  }) async {
    if (username?.isNotEmpty ?? false) {
      await writeUsername(username!);
    }

    if (transactions?.isNotEmpty ?? false) {
      await writeListTransactions(transactions!);
    }

    if (categories?.isNotEmpty ?? false) {
      await writeListCategories(categories!);
    }

    if (locations?.isNotEmpty ?? false) {
      await writeListLocations(locations!);
    }

    updateState();
  }

  /// Updates `List<Category>` ordering
  Future<void> updateCategoriesOrder(
    List<Category> reorderedCategories,
  ) async {
    updateState(
      newCategories: reorderedCategories,
    );
    await writeListCategories(reorderedCategories);
  }

  /// Updates `List<Location>` ordering
  Future<void> updateLocationsOrder(
    List<Location> reorderedLocations,
  ) async {
    updateState(
      newLocations: reorderedLocations,
    );
    await writeListLocations(reorderedLocations);
  }

  /// Clears everything from [Hive] & updates `isLoggedIn`
  Future<void> clearEverything() async {
    await writeSettings(
      getSettings().copyWith(
        isLoggedIn: false,
      ),
    );

    await username.clear();
    await transactions.clear();
    await categories.clear();
    await locations.clear();
  }

  /// Updates `state`
  void updateState({
    Settings? newSettings,
    String? newUsername,
    List<Transaction>? newTransactions,
    List<Category>? newCategories,
    List<Location>? newLocations,
  }) => value = (
    username: newUsername ?? getUsername(),
    transactions: newTransactions ?? getTransactions(),
    categories: newCategories ?? getCategories(),
    locations: newLocations ?? getLocations(),
    settings: newSettings ?? getSettings(),
  );

  /// Called to get `settings` from [Hive]
  Settings getSettings() => settings.values.toList().firstOrNull ?? defaultSettings;

  /// Called to get `username` from [Hive]
  String? getUsername() => username.values.toList().firstOrNull;

  /// Called to get `expandedCategories` from [Hive]
  bool getExpandedCategories() => expandedCategories.values.toList().firstOrNull ?? false;

  /// Called to get `expandedLocations` from [Hive]
  bool getExpandedLocations() => expandedLocations.values.toList().firstOrNull ?? false;

  /// Called to get `transactions` from [Hive]
  List<Transaction> getTransactions() => transactions.values.toList();

  /// Called to get `categories` from [Hive]
  List<Category> getCategories() => categories.values.toList();

  /// Called to get `locations` from [Hive]
  List<Location> getLocations() => locations.values.toList();

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

  /// Stores a new `expandedCategories` in [Hive]
  Future<void> writeExpandedCategories(bool newExpandedCategories) async {
    await expandedCategories.clear();
    await expandedCategories.add(newExpandedCategories);
  }

  /// Stores a new `expandedLocations` in [Hive]
  Future<void> writeExpandedLocations(bool newExpandedLocations) async {
    await expandedLocations.clear();
    await expandedLocations.add(newExpandedLocations);
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

  /// Clears old list and stores a new `List<Location>` in [Hive]
  Future<void> writeListLocations(List<Location> newLocations) async {
    await locations.clear();
    await locations.addAll(newLocations);
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

  /// Stores a new `location` in [Hive]
  Future<void> writeLocation({required Location newLocation}) async {
    await locations.add(newLocation);
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

  /// Deletes a `location` in [Hive]
  Future<void> deleteLocation({required Location location}) async {
    final i = getLocations().indexWhere((l) => l.id == location.id);

    if (i == -1) {
      return;
    }

    final key = locations.keyAt(i);
    await locations.delete(key);
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

  /// Updates a `location` in [Hive]
  Future<void> updateLocation({required Location newLocation}) async {
    final i = getLocations().indexWhere((l) => l.id == newLocation.id);

    if (i == -1) {
      return;
    }

    final key = locations.keyAt(i);
    await locations.put(key, newLocation);
    updateState();
  }
}
