import 'package:intl/intl.dart';

String formatCentsToCurrency(int cents) {
  final format = NumberFormat.currency(
    locale: 'hr_HR',
    symbol: '',
  );

  return format.format(cents / 100).trim();
}

/// Convert display format back to cents (e.g., `1,23` -> `123` cents)
int formatCurrencyToCents(String displayValue) {
  /// Remove any spaces and replace comma with dot for parsing
  final normalizedValue = displayValue.trim().replaceAll('.', '').replaceAll(',', '');
  return int.tryParse(normalizedValue) ?? 0;
}
