import 'package:flutter/material.dart';

import '../../models/month/month.dart';
import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../util/months.dart';

class HomeController extends ValueNotifier<({List<Transaction> transactions, Month activeMonth})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  HomeController({
    required this.logger,
    required this.hive,
  }) : super((
         transactions: hive.getTransactions(),
         activeMonth: getCurrentMonth(
           locale: 'hr',
         ),
       ));

  ///
  /// METHODS
  ///

  /// Updates `state`, depending on passed [DateTime]
  void updateStateByMonth(Month newMonth) {
    final allTransactions = hive.getTransactions();

    /// Filter `allTransactions`
    final filteredTransactions = allTransactions.where((t) => t.createdAt.year == newMonth.date.year && t.createdAt.month == newMonth.date.month).toList();

    value = (
      transactions: List<Transaction>.from(filteredTransactions),
      activeMonth: newMonth,
    );
  }
}
