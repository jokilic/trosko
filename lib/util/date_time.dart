import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String getTimeAgo(DateTime dateTime) => timeago.format(
  dateTime,
  locale: 'hr',
  allowFromNow: true,
);

String getFormattedDate(DateTime dateTime) => DateFormat('dd. MMMM yyyy', 'hr').format(dateTime);
