import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../models/category/category.dart';
import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class TransactionController extends ValueNotifier<({Category? category, int? amountCents, bool nameValid, bool amountValid, bool categoryValid})> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final Transaction? passedTransaction;
  final List<Category> categories;

  TransactionController({
    required this.logger,
    required this.hive,
    required this.passedTransaction,
    required this.categories,
  }) : super((
         category: null,
         amountCents: null,
         nameValid: false,
         amountValid: false,
         categoryValid: false,
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

  ///
  /// INIT
  ///

  void init() {
    final category = categories
        .where(
          (category) => category.id == passedTransaction?.categoryId,
        )
        .toList()
        .firstOrNull;

    updateState(
      category: category,
      nameValid: passedTransaction?.name.isNotEmpty ?? false,
      amountValid: (passedTransaction?.amountCents ?? 0) > 0,
      categoryValid: category != null,
    );

    /// Validation
    nameTextEditingController.addListener(
      () => updateState(
        nameValid: nameTextEditingController.text.trim().isNotEmpty,
      ),
    );
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

  /// Triggered when the user adds a transaction
  Future<bool> addTransaction() async {
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
      createdAt: DateTime.now(),
    );

    /// User modified transaction
    if (passedTransaction != null) {
      await hive.updateTransaction(
        newTransaction: newTransaction,
      );
      return true;
    }
    /// User created new transaction
    else {
      await hive.writeTransaction(
        newTransaction: newTransaction,
      );
      return true;
    }
  }

  /// Updates `state`
  void updateState({
    Category? category,
    int? amountCents,
    bool? nameValid,
    bool? amountValid,
    bool? categoryValid,
  }) => value = (
    category: category ?? value.category,
    amountCents: amountCents ?? value.amountCents,
    nameValid: nameValid ?? value.nameValid,
    amountValid: amountValid ?? value.amountValid,
    categoryValid: categoryValid ?? value.categoryValid,
  );
}
