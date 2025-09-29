import 'package:easy_localization/easy_localization.dart';

import '../models/category/category.dart';
import '../models/transaction/transaction.dart';

List<Transaction> getTransactionsWithinCategory({
  required Category category,
  required List<Transaction> transactions,
}) => transactions.where((transaction) => transaction.categoryId == category.id).toList();

int getTransactionsAmount({
  required Category category,
  required List<Transaction> transactions,
}) {
  final categoryTransactions = getTransactionsWithinCategory(
    category: category,
    transactions: transactions,
  );
  return categoryTransactions.fold<int>(0, (s, t) => s + t.amountCents);
}

List<Category> getSortedCategories({
  required List<Category> categories,
  required List<Transaction> transactions,
}) => List.from(categories)
  ..sort(
    (a, b) =>
        getTransactionsAmount(
          category: b,
          transactions: transactions,
        ).compareTo(
          getTransactionsAmount(
            category: a,
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
