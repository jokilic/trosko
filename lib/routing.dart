import 'package:flutter/material.dart';

import 'models/transaction/transaction.dart';
import 'screens/transaction/transaction_screen.dart';
import 'util/navigation.dart';

/// Opens [TransactionScreen]
void openTransaction(
  BuildContext context, {
  required Transaction? passedTransaction,
}) => pushScreen(
  TransactionScreen(
    passedTransaction: passedTransaction,
    key: ValueKey(passedTransaction?.id),
  ),
  context: context,
);
