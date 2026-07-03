import 'package:flutter/material.dart';

import 'models/category/category.dart';
import 'models/location/location.dart';
import 'models/month/month.dart';
import 'models/notification_payload/notification_payload.dart';
import 'models/transaction/ai_transaction.dart';
import 'models/transaction/transaction.dart';
import 'screens/category/category_screen.dart';
import 'screens/entrance/entrance_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/location/location_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/stats/stats_screen.dart';
import 'screens/transaction/transaction_screen.dart';
import 'screens/voice/voice_screen.dart';
import 'util/navigation.dart';

/// Opens [EntranceScreen]
void openEntrance(BuildContext context) => removeAllAndPushScreen(
  const EntranceScreen(
    key: ValueKey('entrance'),
  ),
  context: context,
);

/// Opens [LoginScreen]
void openLogin(
  BuildContext context, {
  bool popScreenBefore = true,
}) => popScreenBefore
    ? popAndPushScreen(
        const LoginScreen(
          key: ValueKey('login'),
        ),
        context: context,
      )
    : pushScreen(
        const LoginScreen(
          key: ValueKey('login'),
        ),
        context: context,
      );

/// Opens [RegisterScreen]
void openRegister(BuildContext context) => popAndPushScreen(
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
  required ScrollController scrollController,
  required List<Category> categories,
  required List<Location> locations,
  required Function() onTransactionUpdated,
  required String locale,
}) => pushScreen(
  SearchScreen(
    scrollController: scrollController,
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
  required ScrollController scrollController,
  required Function() onStateUpdateTriggered,
}) => pushScreen(
  SettingsScreen(
    scrollController: scrollController,
    onStateUpdateTriggered: onStateUpdateTriggered,
    key: const ValueKey('settings'),
  ),
  context: context,
);

/// Opens [TransactionScreen]
void openTransaction(
  BuildContext context, {
  required ScrollController scrollController,
  required Transaction? passedTransaction,
  required AITransaction? passedAITransaction,
  required List<Category> categories,
  required List<Location> locations,
  required Category? passedCategory,
  required Location? passedLocation,
  required NotificationPayload? passedNotificationPayload,
  required Function() onTransactionUpdated,
  required bool isCopyingTransaction,
  required bool hideBackButton,
}) => pushScreen(
  TransactionScreen(
    scrollController: scrollController,
    passedTransaction: passedTransaction,
    isCopyingTransaction: isCopyingTransaction,
    passedAITransaction: passedAITransaction,
    categories: categories,
    locations: locations,
    passedCategory: passedCategory,
    passedLocation: passedLocation,
    passedNotificationPayload: passedNotificationPayload,
    onTransactionUpdated: onTransactionUpdated,
    hideBackButton: hideBackButton,
    key: ValueKey(isCopyingTransaction ? '${passedTransaction?.id}-copy' : passedTransaction?.id),
  ),
  context: context,
);

/// Opens [CategoryScreen]
void openCategory(
  BuildContext context, {
  required ScrollController scrollController,
  required Category? passedCategory,
}) => pushScreen(
  CategoryScreen(
    scrollController: scrollController,
    passedCategory: passedCategory,
    key: ValueKey(passedCategory?.id),
  ),
  context: context,
);

/// Opens [LocationScreen]
void openLocation(
  BuildContext context, {
  required ScrollController scrollController,
  required Location? passedLocation,
}) => pushScreen(
  LocationScreen(
    scrollController: scrollController,
    passedLocation: passedLocation,
    key: ValueKey(passedLocation?.id),
  ),
  context: context,
);

/// Opens [StatsScreen]
void openStats(
  BuildContext context, {
  required ScrollController scrollController,
  required Month month,
  required List<Transaction> transactions,
  required List<Category> sortedCategories,
  required List<Location> sortedLocations,
}) => pushScreen(
  StatsScreen(
    scrollController: scrollController,
    month: month,
    transactions: transactions,
    categories: sortedCategories,
    locations: sortedLocations,
    key: ValueKey(month),
  ),
  context: context,
);

/// Opens [VoiceScreen]
void openVoice(
  BuildContext context, {
  required ScrollController scrollController,
}) => pushScreen(
  VoiceScreen(
    scrollController: scrollController,
    key: const ValueKey('voice'),
  ),
  context: context,
);
