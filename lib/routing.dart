import 'package:flutter/material.dart';

import 'models/category/category.dart';
import 'models/location/location.dart';
import 'models/month/month.dart';
import 'models/notification_payload/notification_payload.dart';
import 'models/transaction/transaction.dart';
import 'screens/category/category_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/location/location_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';
import 'screens/search/search_screen.dart';
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

/// Opens [SearchScreen]
void openSearch(
  BuildContext context, {
  required List<Category> categories,
  required List<Location> locations,
  required Function() onTransactionUpdated,
  required String locale,
}) => pushScreen(
  SearchScreen(
    categories: categories,
    locations: locations,
    onTransactionUpdated: onTransactionUpdated,
    locale: locale,
    key: const ValueKey('search'),
  ),
  context: context,
);

/// Opens [SettingsScreen]
void openSettings(
  BuildContext context, {
  required Function() onStateUpdateTriggered,
}) => pushScreen(
  SettingsScreen(
    onStateUpdateTriggered: onStateUpdateTriggered,
    key: const ValueKey('settings'),
  ),
  context: context,
);

/// Opens [TransactionScreen]
void openTransaction(
  BuildContext context, {
  required Transaction? passedTransaction,
  required List<Category> categories,
  required List<Location> locations,
  required Category? passedCategory,
  required Location? passedLocation,
  required NotificationPayload? passedNotificationPayload,
  required Function() onTransactionUpdated,
}) => pushScreen(
  TransactionScreen(
    passedTransaction: passedTransaction,
    categories: categories,
    locations: locations,
    passedCategory: passedCategory,
    passedLocation: passedLocation,
    passedNotificationPayload: passedNotificationPayload,
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

/// Opens [LocationScreen]
void openLocation(
  BuildContext context, {
  required Location? passedLocation,
}) => pushScreen(
  LocationScreen(
    passedLocation: passedLocation,
    key: ValueKey(passedLocation?.id),
  ),
  context: context,
);

/// Opens [StatsScreen]
void openStats(
  BuildContext context, {
  required Month month,
  required List<Transaction> transactions,
  required List<Category> sortedCategories,
  required List<Location> sortedLocations,
}) => pushScreen(
  StatsScreen(
    month: month,
    transactions: transactions,
    categories: sortedCategories,
    locations: sortedLocations,
    key: ValueKey(month),
  ),
  context: context,
);
