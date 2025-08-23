import 'package:intl/intl.dart';

import '../models/month/month.dart';

List<Month> getMonthsFromJan2024({required String locale}) {
  final now = DateTime.now();
  final formatter = DateFormat.MMMM(locale);
  final months = <Month>[];

  var date = DateTime(2024);

  while (date.isBefore(DateTime(now.year, now.month + 1))) {
    months.add(
      Month(
        date: date,
        label: formatter.format(date),
      ),
    );

    date = DateTime(
      date.year,
      date.month + 1,
    );
  }

  return months.reversed.toList();
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
