import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../models/category/category.dart';
import '../../models/transaction/transaction.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class TransactionController
    extends
        ValueNotifier<
          ({Category? category, int? amountCents, DateTime? transactionDateTime, bool nameValid, bool amountValid, bool categoryValid, bool dateEditMode, bool timeEditMode})
        >
    implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseService firebase;
  final Transaction? passedTransaction;
  final List<Category> categories;
  final Category? passedCategory;
  final int? passedAmountCents;

  TransactionController({
    required this.logger,
    required this.hive,
    required this.firebase,
    required this.passedTransaction,
    required this.categories,
    required this.passedCategory,
    required this.passedAmountCents,
  }) : super((
         category: null,
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
    text: passedTransaction?.name,
  );
  late final noteTextEditingController = TextEditingController(
    text: passedTransaction?.note,
  );

  final categoryKeys = <String, GlobalKey>{};

  ///
  /// INIT
  ///

  void init() {
    final now = DateTime.now();

    final categoryFromPassedTransaction = categories
        .where(
          (category) => category.id == passedTransaction?.categoryId,
        )
        .toList()
        .firstOrNull;

    final category = categoryFromPassedTransaction ?? passedCategory ?? (categories.length == 1 ? categories.firstOrNull : null);

    final transactionDateTime = passedTransaction?.createdAt ?? now;

    updateState(
      category: category,
      amountCents: passedTransaction?.amountCents ?? passedAmountCents,
      transactionDate: transactionDateTime,
      transactionTime: transactionDateTime,
      nameValid: passedTransaction?.name.isNotEmpty ?? false,
      amountValid: (passedTransaction?.amountCents ?? 0) > 0 || (passedAmountCents ?? 0) > 0,
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
      id: passedTransaction?.id ?? const Uuid().v1(),
      name: name,
      amountCents: value.amountCents!,
      categoryId: value.category!.id,
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
