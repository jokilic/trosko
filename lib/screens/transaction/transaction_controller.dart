import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class TransactionController {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  TransactionController({
    required this.logger,
    required this.hive,
  });

  ///
  /// METHODS
  ///

  /// Triggered when the user adds a transaction
  Future<void> addTransaction() async {
    final transaction = Transaction(
      id: 'hello_transaction_id',
      name: 'Hello transaction',
      amountCents: 52213,
      categoryId: 'hello_category_id',
      createdAt: DateTime.now(),
      note: 'Hello note',
    );

    await hive.writeTransaction(newTransaction: transaction);
  }
}
