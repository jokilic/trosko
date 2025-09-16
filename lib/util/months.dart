import 'package:intl/intl.dart';

import '../models/month/month.dart';
import '../models/transaction/transaction.dart';

/// Returns months covering
/// - the last 12 months ending at the current month
/// - the span from earliest to latest transaction
/// Including empty months
/// Newest first
List<Month> getMonthsForChips({
  required List<Transaction> transactions,
  required String locale,
}) {
  final formatter = DateFormat.MMMM(locale);
  final now = DateTime.now();
  final current = DateTime(now.year, now.month);
  final yearStart = DateTime(current.year, current.month - 11);

  /// If no transactions, just the full year
  if (transactions.isEmpty) {
    final out = <Month>[];
    var cur = yearStart;

    while (!cur.isAfter(current)) {
      out.add(Month(date: cur, label: formatter.format(cur)));
      cur = DateTime(cur.year, cur.month + 1);
    }

    return out.reversed.toList();
  }

  /// Find `min` & `max` transaction dates
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

  final txStart = DateTime(minD.year, minD.month);
  final txEnd = DateTime(maxD.year, maxD.month);

  final start = txStart.isBefore(yearStart) ? txStart : yearStart;
  final end = txEnd.isAfter(current) ? txEnd : current;

  final out = <Month>[];
  var cur = start;

  while (!cur.isAfter(end)) {
    out.add(Month(date: cur, label: formatter.format(cur)));
    cur = DateTime(cur.year, cur.month + 1);
  }

  return out.reversed.toList();
}
