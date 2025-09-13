import 'package:intl/intl.dart';

import '../models/month/month.dart';
import '../models/transaction/transaction.dart';

/// Returns months that have transactions, without empty months
List<Month> getMonthsFromTransactionsWithoutEmptyMonths({
  required List<Transaction> transactions,
  required String locale,
}) {
  final formatter = DateFormat.MMMM(locale);
  final set = <String>{};
  final uniques = <DateTime>[];

  for (final t in transactions) {
    final d = DateTime(t.createdAt.year, t.createdAt.month);
    final key = '${d.year}-${d.month}';

    if (set.add(key)) {
      uniques.add(d);
    }
  }

  /// Always include current month
  final now = DateTime.now();
  final current = DateTime(now.year, now.month);
  if (set.add('${current.year}-${current.month}')) {
    uniques.add(current);
  }

  uniques.sort((a, b) => b.compareTo(a));

  return uniques.map((d) => Month(date: d, label: formatter.format(d))).toList();
}

/// Returns months that have transactions, including empty months
List<Month> getMonthsFromTransactionsWithEmptyMonths({
  required List<Transaction> transactions,
  required String locale,
}) {
  final formatter = DateFormat.MMMM(locale);
  final now = DateTime.now();
  final current = DateTime(now.year, now.month);

  if (transactions.isEmpty) {
    return [
      Month(
        date: current,
        label: formatter.format(current),
      ),
    ];
  }

  /// Find min and max transaction dates
  var minD = transactions.first.createdAt;
  var maxD = minD;
  for (final t in transactions) {
    final d = t.createdAt;

    if (d.isBefore(minD)) {
      minD = d;
    }

    if (d.isAfter(maxD)) {
      maxD = d;
    }
  }

  /// Normalize to month starts
  var cur = DateTime(minD.year, minD.month);
  final lastTxMonth = DateTime(maxD.year, maxD.month);
  final end = lastTxMonth.isAfter(current) ? lastTxMonth : current;

  final out = <Month>[];
  while (!cur.isAfter(end)) {
    out.add(Month(date: cur, label: formatter.format(cur)));
    cur = DateTime(cur.year, cur.month + 1);
  }

  /// newest first
  return out.reversed.toList();
}

Month getCurrentMonth({required String locale}) {
  final now = DateTime.now();
  final formatter = DateFormat.MMMM(locale);

  final date = DateTime(now.year, now.month);

  return Month(
    date: date,
    label: formatter.format(date),
  );
}
