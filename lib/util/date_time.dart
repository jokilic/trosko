import 'package:intl/intl.dart';

String getFormattedDate(DateTime dateTime) => DateFormat('dd. MMMM yyyy', 'hr').format(dateTime);

bool isSameMonth(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
