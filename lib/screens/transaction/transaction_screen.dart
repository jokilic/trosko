import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import 'transaction_controller.dart';
import 'widgets/transaction_amount_widget.dart';

class TransactionScreen extends WatchingStatefulWidget {
  final Transaction? passedTransaction;

  const TransactionScreen({
    required this.passedTransaction,
    required super.key,
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<TransactionController>(
      () => TransactionController(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
      ),
      instanceName: widget.passedTransaction?.id,
    );
  }

  @override
  void dispose() {
    getIt.unregister<TransactionController>(
      instanceName: widget.passedTransaction?.id,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<TransactionController>(
      instanceName: widget.passedTransaction?.id,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          controller.addTransaction();
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.money_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              /// TITLE
              ///
              Text(
                'New transaction 💸',
                style: context.textStyles.appBarTitle,
              ),

              ///
              /// AMOUNT KEYPAD
              ///
              TransactionAmountWidget(
                onValueChanged: (value) {},
                initialCents: 412313,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
