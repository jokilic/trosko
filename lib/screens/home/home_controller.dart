import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/category/category.dart';
import '../../models/month/month.dart';
import '../../models/transaction/transaction.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../util/date_time.dart';
import '../../util/group_transactions.dart';

class HomeController
    extends ValueNotifier<({List<dynamic> datesAndTransactions, List<Month>? activeMonths, List<Category>? activeCategories, bool expandedCategories, bool expandedLocations})>
    implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseService firebase;

  HomeController({
    required this.logger,
    required this.hive,
    required this.firebase,
  }) : super((
         datesAndTransactions: [],
         activeMonths: null,
         activeCategories: null,
         expandedCategories: false,
         expandedLocations: false,
       ));

  ///
  /// VARIABLES
  ///

  AnimationController? shakeFabController;

  ///
  /// INIT
  ///

  void init({required String locale}) {
    updateState(
      locale: locale,
    );

    updateExpandedValues(
      newExpandedCategories: hive.getExpandedCategories(),
      newExpandedLocations: hive.getExpandedLocations(),
    );
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    shakeFabController?.dispose();
  }

  ///
  /// METHODS
  ///

  /// Triggered when the user presses some [Month] chip
  void onMonthChipPressed({
    required Month? month,
    required List<Month>? activeMonths,
    required String languageCode,
  }) {
    var newMonths = <Month>[];

    /// Some month is pressed
    if (month != null && !month.isAll) {
      /// There were no filtered months, add the pressed month to the list
      if (activeMonths == null || activeMonths.isEmpty) {
        newMonths = [month];
      }
      /// There were filtered months, handle pressed month
      else {
        newMonths = List.from(activeMonths);

        /// Remove pressed month
        if (newMonths.contains(month)) {
          newMonths.remove(month);
        }
        /// Add pressed month
        else {
          newMonths.add(month);
        }
      }
    }

    updateState(
      newMonths: newMonths,
      locale: languageCode,
    );
  }

  /// Triggered when the user presses some [Category]
  void onCategoryPressed({
    required Category? category,
    required List<Category>? activeCategories,
    required String languageCode,
  }) {
    var newCategories = <Category>[];

    /// Some category is pressed
    if (category != null) {
      /// There were no filtered categories, add the pressed category to the list
      if (activeCategories == null || activeCategories.isEmpty) {
        newCategories = [category];
      }
      /// There were filtered categories, handle pressed category
      else {
        newCategories = List.from(activeCategories);

        /// Remove pressed category
        if (newCategories.contains(category)) {
          newCategories.remove(category);
        }
        /// Add pressed category
        else {
          newCategories.add(category);
        }
      }
    }

    updateState(
      newCategories: newCategories,
      locale: languageCode,
    );
  }

  List<Transaction> getAllTransactionsFromMonth(Month month) {
    final all = hive.getTransactions();

    /// Apply filters and sort
    final filtered = all.where((t) => isSameMonth(t.createdAt, month.date)).toList()
      ..sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

    /// Return proper `transactions`
    return filtered;
  }

  /// Trigger FAB animation
  void triggerFabAnimation() {
    shakeFabController?.reset();
    shakeFabController?.forward();
  }

  /// Updates `state`, depending on passed [List<Month>] or [List<Category>]
  void updateState({
    required String locale,
    List<Month>? newMonths,
    List<Category>? newCategories,
  }) {
    final all = hive.getTransactions();

    /// Month filter
    List<Month>? targetMonths;

    /// `newMonths` is passed, handle logic
    if (newMonths != null) {
      /// `All` is selected or list is empty, treat as showing all (`null`)
      if (newMonths.any((month) => month.isAll) || newMonths.isEmpty) {
        targetMonths = null;
      } else {
        targetMonths = newMonths;
      }
    }
    /// `newMonths` is not passed, keep old filter
    else {
      targetMonths = value.activeMonths;
    }

    /// Category filter
    List<Category>? targetCategories;

    /// `newCategories` is passed, handle logic
    if (newCategories != null) {
      targetCategories = newCategories;
    }
    /// `newCategories` is not passed, keep old filter
    else {
      targetCategories = value.activeCategories;
    }

    /// Apply filters and sort
    final filtered =
        all.where((t) {
          final monthOk =
              targetMonths == null ||
              targetMonths.isEmpty ||
              targetMonths.any(
                (m) => isSameMonth(t.createdAt, m.date),
              );

          final categoryOk =
              targetCategories == null ||
              targetCategories.isEmpty ||
              targetCategories.any(
                (c) => t.categoryId == c.id,
              );

          return monthOk && categoryOk;
        }).toList()..sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );

    /// Update `state`
    value = (
      datesAndTransactions: getGroupedTransactionsByDate(
        filtered,
        locale: locale,
      ),
      activeMonths: targetMonths,
      activeCategories: targetCategories,
      expandedCategories: value.expandedCategories,
      expandedLocations: value.expandedLocations,
    );
  }

  /// Updates `expandedCategories` and `expandedLocations` values
  void updateExpandedValues({
    bool? newExpandedCategories,
    bool? newExpandedLocations,
  }) => value = (
    datesAndTransactions: value.datesAndTransactions,
    activeMonths: value.activeMonths,
    activeCategories: value.activeCategories,
    expandedCategories: newExpandedCategories ?? value.expandedCategories,
    expandedLocations: newExpandedLocations ?? value.expandedLocations,
  );

  /// Triggered when the user toogles categories
  Future<void> toggleCategories() async {
    final newValue = !value.expandedCategories;

    unawaited(
      hive.writeExpandedCategories(newValue),
    );

    updateExpandedValues(
      newExpandedCategories: newValue,
    );
  }

  /// Triggered when the user toogles locations
  Future<void> toggleLocations() async {
    final newValue = !value.expandedLocations;

    unawaited(
      hive.writeExpandedLocations(newValue),
    );

    updateExpandedValues(
      newExpandedLocations: newValue,
    );
  }

  // Triggered when the user deletes transaction
  Future<void> deleteTransaction({
    required Transaction transaction,
    required String locale,
  }) async {
    await hive.deleteTransaction(
      transaction: transaction,
    );

    unawaited(
      firebase.deleteTransaction(
        transaction: transaction,
      ),
    );

    updateState(
      locale: locale,
    );
  }
}
