import 'package:flutter/material.dart';

import 'models/category/category.dart';
import 'models/month/month.dart';
import 'models/transaction/transaction.dart';
import 'screens/category/category_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/stats/stats_screen.dart';
import 'screens/transaction/transaction_screen.dart';
import 'util/navigation.dart';

/// Opens [LoginScreen]
void openLogin(BuildContext context) => removeAllAndPushScreen(
  const LoginScreen(
    key: ValueKey('login'),
  ),
  context: context,
);

/// Opens [RegisterScreen]
void openRegister(BuildContext context) => removeAllAndPushScreen(
  const RegisterScreen(
    key: ValueKey('register'),
  ),
  context: context,
);

/// Opens [HomeScreen]
void openHome(BuildContext context) => removeAllAndPushScreen(
  const HomeScreen(
    key: ValueKey('home'),
  ),
  context: context,
);

/// Opens [SettingsScreen]
void openSettings(
  BuildContext context, {
  required Function() onRefetchCompleted,
}) => pushScreen(
  SettingsScreen(
    onRefetchCompleted: onRefetchCompleted,
    key: const ValueKey('settings'),
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

/// Opens [StatsScreen]
void openStats(
  BuildContext context, {
  required Month month,
  required List<Transaction> transactions,
  required List<Category> sortedCategories,
}) => pushScreen(
  StatsScreen(
    month: month,
    transactions: transactions,
    categories: sortedCategories,
    key: ValueKey(month),
  ),
  context: context,
);
