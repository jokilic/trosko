import 'package:flutter/material.dart';

import '../../models/category/category.dart';
import '../../models/month/month.dart';
import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../util/group_transactions.dart';
import '../../util/months.dart';

class HomeController extends ValueNotifier<({List<dynamic> datesAndTransactions, Month activeMonth, Category? activeCategory})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  HomeController({
    required this.logger,
    required this.hive,
  }) : super((
         datesAndTransactions: getGroupedTransactions(
           hive.getTransactions(),
         ),
         activeMonth: getCurrentMonth(
           locale: 'hr',
         ),
         activeCategory: null,
       ));

  ///
  /// METHODS
  ///

  /// Updates `state`, depending on passed [Month] or [Category]
  void updateState({Month? newMonth, Category? newCategory}) {
    final allTransactions = hive.getTransactions();

    /// Filter `allTransactions`
    final filteredTransactions = allTransactions.where((t) {
      final monthOk = newMonth == null || newMonth == value.activeMonth || t.createdAt.year == newMonth.date.year && t.createdAt.month == newMonth.date.month;

      final categoryOk = newCategory == null || newCategory == value.activeCategory || t.categoryId == newCategory.id;

      return monthOk && categoryOk;
    }).toList();

    /// Create a new `List<Transaction>`
    final newTransactions = List<Transaction>.from(filteredTransactions);

    /// Update `state`
    value = (
      datesAndTransactions: getGroupedTransactions(newTransactions),
      activeMonth: newMonth ?? value.activeMonth,
      activeCategory: newCategory == value.activeCategory ? null : newCategory ?? value.activeCategory,
    );
  }
}
