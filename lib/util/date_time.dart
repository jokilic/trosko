import 'package:timeago/timeago.dart' as timeago;

String getTimeAgo(DateTime dateTime) => timeago.format(
  dateTime,
  locale: 'hr',
  allowFromNow: true,
);
