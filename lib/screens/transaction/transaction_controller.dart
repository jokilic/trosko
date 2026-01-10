import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../models/category/category.dart';
import '../../models/location/location.dart';
import '../../models/notification_payload/notification_payload.dart';
import '../../models/transaction/ai_transaction.dart';
import '../../models/transaction/transaction.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

/// Class to distinguish `no argument passed` from `explicitly passed null`
class TransactionStateNoChange {
  const TransactionStateNoChange();
}

const transactionStateNoChange = TransactionStateNoChange();

class TransactionController
    extends
        ValueNotifier<
          ({
            Category? category,
            Location? location,
            int? amountCents,
            DateTime? transactionDateTime,
            bool nameValid,
            bool amountValid,
            bool categoryValid,
            bool dateEditMode,
            bool timeEditMode,
          })
        >
    implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseService firebase;
  final Transaction? passedTransaction;
  final AITransaction? passedAITransaction;
  final List<Category> categories;
  final List<Location> locations;
  final Category? passedCategory;
  final Location? passedLocation;
  final NotificationPayload? passedNotificationPayload;

  TransactionController({
    required this.logger,
    required this.hive,
    required this.firebase,
    required this.passedTransaction,
    required this.passedAITransaction,
    required this.categories,
    required this.locations,
    required this.passedCategory,
    required this.passedLocation,
    required this.passedNotificationPayload,
  }) : super((
         category: null,
         location: null,
         amountCents: null,
         transactionDateTime: null,
         nameValid: false,
         amountValid: false,
         categoryValid: false,
         dateEditMode: false,
         timeEditMode: false,
       ));

  ///
  /// VARIABLES
  ///

  late final nameTextEditingController = TextEditingController(
    text: passedTransaction?.name ?? passedAITransaction?.name ?? passedNotificationPayload?.name,
  );
  late final noteTextEditingController = TextEditingController(
    text: passedTransaction?.note ?? passedAITransaction?.note,
  );

  final categoryKeys = <String, GlobalKey>{};
  final locationKeys = <String, GlobalKey>{};

  ///
  /// INIT
  ///

  void init() {
    final now = DateTime.now();

    final categoryFromPassedTransaction = categories
        .where(
          (category) => category.id == (passedTransaction?.categoryId ?? passedAITransaction?.categoryId),
        )
        .toList()
        .firstOrNull;

    final category = categoryFromPassedTransaction ?? passedCategory;

    final locationFromPassedTransaction = locations
        .where(
          (location) => location.id == (passedTransaction?.locationId ?? passedAITransaction?.locationId),
        )
        .toList()
        .firstOrNull;

    final location = locationFromPassedTransaction ?? passedLocation;

    final transactionDateTime = passedTransaction?.createdAt ?? passedAITransaction?.createdAt ?? passedNotificationPayload?.createdAt ?? now;

    updateState(
      category: category,
      location: location,
      amountCents: passedTransaction?.amountCents ?? passedAITransaction?.amountCents ?? passedNotificationPayload?.amountCents,
      transactionDate: transactionDateTime,
      transactionTime: transactionDateTime,
      nameValid: passedTransaction?.name.isNotEmpty ?? passedAITransaction?.name?.isNotEmpty ?? passedNotificationPayload?.name?.isNotEmpty ?? false,
      amountValid: (passedTransaction?.amountCents ?? 0) > 0 || (passedAITransaction?.amountCents ?? 0) > 0 || (passedNotificationPayload?.amountCents ?? 0) > 0,
      categoryValid: category != null,
      dateEditMode: false,
      timeEditMode: false,
    );

    /// Validation
    nameTextEditingController.addListener(
      () => updateState(
        nameValid: nameTextEditingController.text.trim().isNotEmpty,
      ),
    );

    /// Scroll to `activeCategory`
    if (value.category != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = categoryKeys[value.category?.id];
        final ctx = key?.currentContext;

        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0.5,
          );
        }
      });
    }

    /// Scroll to `activeLocation`
    if (value.location != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = locationKeys[value.location?.id];
        final ctx = key?.currentContext;

        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0.5,
          );
        }
      });
    }
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    nameTextEditingController.dispose();
    noteTextEditingController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Triggered when the user writes in the [TransactionAmountWidget]
  void transactionAmountChanged(int newCents) => updateState(
    amountCents: newCents,
    amountValid: newCents > 0,
  );

  /// Triggered when the user presses a [Category]
  void categoryChanged(Category newCategory) => updateState(
    category: newCategory,
    categoryValid: true,
  );

  /// Triggered when the user presses a [Location]
  void locationChanged(Location newLocation) => updateState(
    location: value.location?.id == newLocation.id ? null : newLocation,
  );

  /// Triggered when the user enables date edit mode
  void dateEditModeChanged() => updateState(dateEditMode: true);

  /// Triggered when the user enables time edit mode
  void timeEditModeChanged() => updateState(timeEditMode: true);

  /// Triggered when the user changes date
  void dateChanged(DateTime newDate) => updateState(transactionDate: newDate);

  /// Triggered when the user changes time
  void timeChanged(DateTime newTime) => updateState(transactionTime: newTime);

  /// Triggered when the user adds transaction
  Future<void> addTransaction() async {
    /// Get [TextField] values
    final name = nameTextEditingController.text.trim();
    final note = noteTextEditingController.text.trim();

    /// Create [Transaction]
    final newTransaction = Transaction(
      id: passedTransaction?.id ?? passedAITransaction?.id ?? const Uuid().v1(),
      name: name,
      amountCents: value.amountCents!,
      categoryId: value.category!.id,
      locationId: value.location?.id,
      note: note.isNotEmpty ? note : null,
      createdAt: value.transactionDateTime ?? DateTime.now(),
    );

    /// User modified transaction
    if (passedTransaction != null) {
      await hive.updateTransaction(
        newTransaction: newTransaction,
      );

      unawaited(
        firebase.updateTransaction(
          newTransaction: newTransaction,
        ),
      );
    }
    /// User created new transaction
    else {
      await hive.writeTransaction(
        newTransaction: newTransaction,
      );

      unawaited(
        firebase.writeTransaction(
          newTransaction: newTransaction,
        ),
      );
    }
  }

  /// Triggered when the user deletes transaction
  Future<void> deleteTransaction() async {
    if (passedTransaction != null) {
      await hive.deleteTransaction(
        transaction: passedTransaction!,
      );

      unawaited(
        firebase.deleteTransaction(
          transaction: passedTransaction!,
        ),
      );
    }
  }

  /// Updates `state`
  void updateState({
    Category? category,
    Object? location = transactionStateNoChange,
    int? amountCents,
    DateTime? transactionDate,
    DateTime? transactionTime,
    bool? nameValid,
    bool? amountValid,
    bool? categoryValid,
    bool? dateEditMode,
    bool? timeEditMode,
  }) => value = (
    category: category ?? value.category,
    location: identical(location, transactionStateNoChange) ? value.location : location as Location?,
    amountCents: amountCents ?? value.amountCents,
    transactionDateTime: getTransactionDateTime(
      transactionDate: transactionDate,
      transactionTime: transactionTime,
    ),
    nameValid: nameValid ?? value.nameValid,
    amountValid: amountValid ?? value.amountValid,
    categoryValid: categoryValid ?? value.categoryValid,
    dateEditMode: dateEditMode ?? value.dateEditMode,
    timeEditMode: timeEditMode ?? value.timeEditMode,
  );

  /// Returns proper DateTime from passed `transactionDate` and `transactionTime`
  DateTime? getTransactionDateTime({
    required DateTime? transactionDate,
    required DateTime? transactionTime,
  }) {
    final day = transactionDate?.day ?? value.transactionDateTime?.day;
    final month = transactionDate?.month ?? value.transactionDateTime?.month;
    final year = transactionDate?.year ?? value.transactionDateTime?.year;
    final hour = transactionTime?.hour ?? value.transactionDateTime?.hour;
    final minute = transactionTime?.minute ?? value.transactionDateTime?.minute;

    if (day != null && month != null && year != null && hour != null && minute != null) {
      return DateTime(year, month, day, hour, minute);
    }

    return null;
  }
}
