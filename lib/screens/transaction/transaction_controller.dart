import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class TransactionController implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final Transaction? passedTransaction;

  TransactionController({
    required this.logger,
    required this.hive,
    required this.passedTransaction,
  });

  ///
  /// VARIABLES
  ///

  late final nameTextEditingController = TextEditingController(
    text: passedTransaction?.name,
  );
  late final noteTextEditingController = TextEditingController(
    text: passedTransaction?.note,
  );

  late String? categoryId = passedTransaction?.categoryId;

  late int? amountCents = passedTransaction?.amountCents;

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
  void transactionAmountChanged(int newCents) => amountCents = newCents;

  /// Triggered when the user adds a transaction
  Future<bool> addTransaction() async {
    /// Get [TextField] values
    final name = nameTextEditingController.text.trim();
    final note = noteTextEditingController.text.trim();

    /// `name` is not proper
    if (name.isEmpty) {
      logger.e('Name is not proper');
      return false;
    }

    /// `amountCents` is not proper
    if ((amountCents ?? 0) <= 0) {
      logger.e('AmountCents is not proper');
      return false;
    }

    /// `categoryId` is not proper
    if (categoryId?.isEmpty ?? true) {
      logger.e('CategoryId is not proper');
      return false;
    }

    /// Create [Transaction]
    final newTransaction = Transaction(
      id: passedTransaction?.id ?? const Uuid().v1(),
      name: name,
      amountCents: amountCents!,
      categoryId: categoryId!,
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
}
