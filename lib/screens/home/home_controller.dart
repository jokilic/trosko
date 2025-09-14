import 'package:flutter/material.dart';

import '../../models/category/category.dart';
import '../../models/month/month.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../util/date_time.dart';
import '../../util/group_transactions.dart';

class HomeController extends ValueNotifier<({List<dynamic> datesAndTransactions, Month? activeMonth, Category? activeCategory})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  HomeController({
    required this.logger,
    required this.hive,
  }) : super((
         datesAndTransactions: [],
         activeMonth: null,
         activeCategory: null,
       ));

  ///
  /// INIT
  ///

  void init() {
    updateState();
  }

  ///
  /// METHODS
  ///

  /// Updates `state`, depending on passed [Month] or [Category]
  void updateState({Month? newMonth, Category? newCategory}) {
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

    /// Update state
    value = (
      datesAndTransactions: getGroupedTransactions(filtered),
      activeMonth: targetMonth,
      activeCategory: targetCategory,
    );
  }
}
