import 'package:flutter/material.dart';

import 'models/category/category.dart';
import 'models/transaction/transaction.dart';
import 'screens/transaction/transaction_screen.dart';
import 'util/navigation.dart';

/// Opens [TransactionScreen]
void openTransaction(
  BuildContext context, {
  required Transaction? passedTransaction,
  required List<Category> categories,
}) => pushScreen(
  TransactionScreen(
    passedTransaction: passedTransaction,
    categories: categories,
    key: ValueKey(passedTransaction?.id),
  ),
  context: context,
);
