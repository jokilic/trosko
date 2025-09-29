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
