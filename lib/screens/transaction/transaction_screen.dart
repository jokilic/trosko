import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/category/category.dart';
import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import '../../widgets/trosko_text_field.dart';
import 'transaction_controller.dart';
import 'widgets/transaction_amount_widget.dart';
import 'widgets/transaction_category.dart';

class TransactionScreen extends WatchingStatefulWidget {
  final Transaction? passedTransaction;
  final List<Category> categories;

  const TransactionScreen({
    required this.passedTransaction,
    required this.categories,
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
        passedTransaction: widget.passedTransaction,
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
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          children: [
            ///
            /// TOP TITLE
            ///
            Text(
              widget.passedTransaction != null ? 'Update transaction' : 'New transaction',
              style: context.textStyles.homeTopTitle,
            ),
            const SizedBox(height: 24),

            ///
            /// NAME TEXT FIELD
            ///
            TroskoTextField(
              autofocus: false,
              controller: controller.nameTextEditingController,
              fillColor: context.colors.secondary,
              labelText: 'What did you buy?',
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 28),

            ///
            /// AMOUNT TITLE
            ///
            Text(
              'How much did you spend?',
              style: context.textStyles.transactionAmountTitle,
            ),
            const SizedBox(height: 20),

            ///
            /// AMOUNT KEYPAD
            ///
            TransactionAmountWidget(
              onValueChanged: controller.transactionAmountChanged,
              initialCents: widget.passedTransaction?.amountCents ?? 0,
            ),
            const SizedBox(height: 28),

            ///
            /// CATEGORY TITLE
            ///
            Text(
              'What is the category?',
              style: context.textStyles.transactionAmountTitle,
            ),
            const SizedBox(height: 12),

            ///
            /// CATEGORIES
            ///
            SizedBox(
              height: 112,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                // itemCount: widget.categories.length,
                itemCount: 8,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) => TransactionCategory(
                  onPressed: (category) {},
                  // category: widget.categories[index],
                  category: Category(
                    id: 'id',
                    name: 'name',
                    color: Colors.blue,
                    icon: '',
                  ),
                ),
                separatorBuilder: (_, __) => const SizedBox(width: 8),
              ),
            ),

            ///
            /// NOTE TITLE
            ///
            Text(
              'Additional notes about it?',
              style: context.textStyles.transactionAmountTitle,
            ),
            const SizedBox(height: 12),

            ///
            /// NOTE TEXT FIELD
            ///
            TroskoTextField(
              autofocus: false,
              controller: controller.nameTextEditingController,
              fillColor: context.colors.tertiary,
              labelText: 'Additional notes about it?',
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 28),

            ///
            /// ADD TRANSACTION BUTTON
            ///
            FilledButton(
              onPressed: controller.addTransaction,
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.background,
              ),
              child: Text(
                'Add transaction'.toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
