import 'package:collection/collection.dart';

import '../constants/enums.dart';
import '../models/transaction/transaction.dart';

DateGroup getDateGroup(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final startOfWeek = today.subtract(Duration(days: now.weekday - 1));
  final firstOfThisMonth = DateTime(now.year, now.month);
  final firstOfLastMonth = DateTime(now.year, now.month - 1);

  if (date.isAfter(today.subtract(const Duration(seconds: 1)))) {
    return DateGroup.today;
  }
  if (date.isAfter(yesterday.subtract(const Duration(seconds: 1))) && date.isBefore(today)) {
    return DateGroup.yesterday;
  }
  if (date.isAfter(startOfWeek)) {
    return DateGroup.thisWeek;
  }
  if (date.isAfter(firstOfThisMonth)) {
    return DateGroup.thisMonth;
  }
  if (date.isAfter(firstOfLastMonth)) {
    return DateGroup.lastMonth;
  }
  return DateGroup.older;
}

String getGroupLabel(DateGroup group) => switch (group) {
  DateGroup.today => 'Today',
  DateGroup.yesterday => 'Yesterday',
  DateGroup.thisWeek => 'This week',
  DateGroup.thisMonth => 'This month',
  DateGroup.lastMonth => 'Last month',
  DateGroup.older => 'Older',
};

List<dynamic> getGroupedTransactions(List<Transaction> transactions) {
  final grouped = groupBy(
    transactions,
    (t) => getDateGroup(t.createdAt),
  );

  final items = <dynamic>[];
  for (final group in DateGroup.values) {
    final txs = grouped[group];
    if (txs != null && txs.isNotEmpty) {
      items
        ..add(group)
        ..addAll(txs);
    }
  }
  return items;
}
