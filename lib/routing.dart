import 'package:flutter/material.dart';

import 'models/category/category.dart';
import 'models/transaction/transaction.dart';
import 'screens/category/category_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/transaction/transaction_screen.dart';
import 'util/navigation.dart';

/// Opens [LoginScreen]
void openLogin(BuildContext context) => pushScreen(
  const LoginScreen(
    key: ValueKey('login'),
  ),
  context: context,
);

/// Opens [HomeScreen]
void openHome(BuildContext context) => pushScreen(
  const HomeScreen(
    key: ValueKey('home'),
  ),
  context: context,
);

/// Opens [TransactionScreen]
void openTransaction(
  BuildContext context, {
  required Transaction? passedTransaction,
  required List<Category> categories,
  required Function() onTransactionUpdated,
}) => pushScreen(
  TransactionScreen(
    passedTransaction: passedTransaction,
    categories: categories,
    onTransactionUpdated: onTransactionUpdated,
    key: ValueKey(passedTransaction?.id),
  ),
  context: context,
);

/// Opens [CategoryScreen]
void openCategory(
  BuildContext context, {
  required Category? passedCategory,
}) => pushScreen(
  CategoryScreen(
    passedCategory: passedCategory,
    key: ValueKey(passedCategory?.id),
  ),
  context: context,
);
