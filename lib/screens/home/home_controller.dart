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

class HomeController extends ValueNotifier<({List<dynamic> datesAndTransactions, Month? activeMonth, Category? activeCategory})> implements Disposable {
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
         activeMonth: null,
         activeCategory: null,
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

  /// Updates `state`, depending on passed [Month] or [Category]
  void updateState({
    required String locale,
    Month? newMonth,
    Category? newCategory,
  }) {
    final all = hive.getTransactions();

    /// Month filter
    Month? targetMonth;
    if (newMonth != null) {
      /// Clear month filter
      if (newMonth.isAll) {
        targetMonth = null;
      }
      /// Enable month filter
      else {
        targetMonth = (value.activeMonth != null && isSameMonth(newMonth.date, value.activeMonth!.date)) ? null : newMonth;
      }
    }
    /// Keep old filter
    else {
      targetMonth = value.activeMonth;
    }

    /// Category filter
    Category? targetCategory;

    /// Enable category filter
    if (newCategory != null) {
      targetCategory = (value.activeCategory != null && value.activeCategory!.id == newCategory.id) ? null : newCategory;
    }
    /// Keep old filter
    else {
      targetCategory = value.activeCategory;
    }

    /// Apply filters and sort
    final filtered =
        all.where((t) {
          final monthOk = targetMonth == null || isSameMonth(t.createdAt, targetMonth.date);
          final categoryOk = targetCategory == null || t.categoryId == targetCategory.id;

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
      activeMonth: targetMonth,
      activeCategory: targetCategory,
    );
  }

  /// Triggered when the user deletes transaction
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
