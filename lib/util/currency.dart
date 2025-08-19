import 'package:intl/intl.dart';

String formatCurrency(int cents) {
  final format = NumberFormat.currency(
    locale: 'hr_HR',
    symbol: '',
  );

  return format.format(cents / 100).trim();
}
