import 'package:easy_localization/easy_localization.dart';

import '../models/category/category.dart';
import '../models/location/location.dart';
import '../models/transaction/transaction.dart';

Category? getCategoryById({
  required String id,
  required List<Category> categories,
}) => categories
    .where(
      (c) => c.id == id,
    )
    .firstOrNull;

Map<String, int> calculateCategoryTotals({
  required List<Transaction> transactions,
}) {
  final totals = <String, int>{};

  for (final transaction in transactions) {
    totals[transaction.categoryId] = (totals[transaction.categoryId] ?? 0) + transaction.amountCents;
  }

  return totals;
}

Location? getLocationById({
  required String id,
  required List<Location> locations,
}) => locations
    .where(
      (l) => l.id == id,
    )
    .firstOrNull;

Map<String, int> calculateLocationTotals({
  required List<Transaction> transactions,
}) {
  final totals = <String, int>{};

  for (final transaction in transactions) {
    if (transaction.locationId != null) {
      totals[transaction.locationId!] = (totals[transaction.locationId] ?? 0) + transaction.amountCents;
    }
  }

  return totals;
}

List<Transaction> getTransactionsWithinCategory({
  required Category category,
  required List<Transaction> transactions,
}) => transactions.where((transaction) => transaction.categoryId == category.id).toList();

List<Transaction> getTransactionsWithinLocation({
  required Location location,
  required List<Transaction> transactions,
}) => transactions.where((transaction) => transaction.locationId == location.id).toList();

int getCategoryTransactionsAmount({
  required Category category,
  required List<Transaction> transactions,
}) {
  final categoryTransactions = getTransactionsWithinCategory(
    category: category,
    transactions: transactions,
  );
  return categoryTransactions.fold<int>(0, (s, t) => s + t.amountCents);
}

int getLocationTransactionsAmount({
  required Location location,
  required List<Transaction> transactions,
}) {
  final locationTransactions = getTransactionsWithinLocation(
    location: location,
    transactions: transactions,
  );
  return locationTransactions.fold<int>(0, (s, t) => s + t.amountCents);
}

List<Category> getSortedCategories({
  required List<Category> categories,
  required List<Transaction> transactions,
}) => List.from(categories)
  ..sort(
    (a, b) =>
        getCategoryTransactionsAmount(
          category: b,
          transactions: transactions,
        ).compareTo(
          getCategoryTransactionsAmount(
            category: a,
            transactions: transactions,
          ),
        ),
  );

List<Location> getSortedLocations({
  required List<Location> locations,
  required List<Transaction> transactions,
}) => List.from(locations)
  ..sort(
    (a, b) =>
        getLocationTransactionsAmount(
          location: b,
          transactions: transactions,
        ).compareTo(
          getLocationTransactionsAmount(
            location: a,
            transactions: transactions,
          ),
        ),
  );

String getStatsSubtitle({
  required int numberOfTransactions,
  required String languageCode,
}) {
  /// English language
  if (languageCode == 'en') {
    return switch (numberOfTransactions) {
      1 => 'statsExpenseNumberSingular'.tr(
        args: ['$numberOfTransactions'],
      ),

      _ => 'statsExpenseNumberPlural'.tr(
        args: ['$numberOfTransactions'],
      ),
    };
  } else {
    return switch (numberOfTransactions) {
      1 => 'statsExpenseNumberSingular'.tr(
        args: ['$numberOfTransactions'],
      ),
      2 || 3 || 4 => 'statsExpenseNumberPluralSmall'.tr(
        args: ['$numberOfTransactions'],
      ),
      _ => 'statsExpenseNumberPlural'.tr(
        args: ['$numberOfTransactions'],
      ),
    };
  }
}
