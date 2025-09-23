import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/day_header/day_header.dart';
import '../models/transaction/transaction.dart';
import 'date_time.dart';

/// [DayHeader, Transaction, Transaction, DayHeader, ...]
List<Object> getGroupedTransactionsByDate(
  List<Transaction> transactions, {
  required String locale,
}) {
  final now = DateTime.now();
  final today = toYmd(now);
  final yesterday = today.subtract(const Duration(days: 1));

  final dayFormatter = DateFormat('dd. MMMM', locale);
  final dayFormatterYear = DateFormat('dd. MMMM yyyy', locale);

  String labelFor(DateTime d) {
    if (d == today) {
      return 'transactionsToday'.tr();
    }

    if (d == yesterday) {
      return 'transactionsYesterday'.tr();
    }

    return d.year == today.year ? dayFormatter.format(d) : dayFormatterYear.format(d);
  }

  final grouped = groupBy<Transaction, DateTime>(
    transactions,
    (t) => toYmd(t.createdAt),
  );

  final days = grouped.keys.toList()
    ..sort(
      (a, b) => b.compareTo(a),
    );

  final items = <Object>[];

  for (final day in days) {
    final txs = [...grouped[day]!]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final amountCents = txs.fold<int>(0, (s, t) => s + t.amountCents);

    items
      ..add(
        DayHeader(
          label: labelFor(day),
          amountCents: amountCents,
          day: day,
        ),
      )
      ..addAll(txs);
  }

  return items;
}
