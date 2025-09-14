import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/enums.dart';
import '../../models/category/category.dart';
import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/date_time.dart';
import '../../util/dependencies.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_text_field.dart';
import 'transaction_controller.dart';
import 'widgets/transaction_amount_widget.dart';
import 'widgets/transaction_category.dart';
import 'widgets/transaction_date_checkbox.dart';

class TransactionScreen extends WatchingStatefulWidget {
  final Transaction? passedTransaction;
  final List<Category> categories;
  final Function() onTransactionUpdated;

  const TransactionScreen({
    required this.passedTransaction,
    required this.categories,
    required this.onTransactionUpdated,
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
        categories: widget.categories,
      ),
      instanceName: widget.passedTransaction?.id,
      afterRegister: (controller) => controller.init(),
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

    final state = watchIt<TransactionController>(
      instanceName: widget.passedTransaction?.id,
    ).value;

    final chosenCategory = state.category;

    final validated = state.nameValid && state.amountValid && state.dateValid && state.categoryValid;
    final activeDateEnum = state.activeDateEnum;
    final date = state.transactionDate;

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          ///
          /// APP BAR
          ///
          TroskoAppBar(
            leadingWidget: IconButton(
              onPressed: Navigator.of(context).pop,
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: context.colors.buttonBackground,
                highlightColor: context.colors.buttonBackground,
              ),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: context.colors.text,
                size: 28,
              ),
            ),
            actionWidgets: [
              if (widget.passedTransaction != null)
                IconButton(
                  onPressed: () async {
                    await controller.deleteTransaction();
                    widget.onTransactionUpdated();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: context.colors.delete,
                    size: 28,
                  ),
                ),
            ],
            smallTitle: widget.passedTransaction != null ? 'Update transaction' : 'New transaction',
            bigTitle: widget.passedTransaction != null ? 'Update transaction' : 'New transaction',
            bigSubtitle: widget.passedTransaction != null ? 'Edit details of an existing expense' : 'Create a new expense',
          ),

          ///
          /// CONTENT
          ///
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 24),

                ///
                /// NAME TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    autofocus: true,
                    controller: controller.nameTextEditingController,
                    labelText: 'Transaction title',
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// AMOUNT KEYPAD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TransactionAmountWidget(
                    onValueChanged: controller.transactionAmountChanged,
                    initialCents: widget.passedTransaction?.amountCents ?? 0,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// CATEGORIES
                ///
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colors.text,
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IntrinsicHeight(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          widget.categories.length,
                          (index) {
                            final category = widget.categories[index];

                            return TransactionCategory(
                              isActive: chosenCategory == category,
                              onPressed: controller.categoryChanged,
                              category: category,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// DATE
                ///
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colors.text,
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///
                      /// TODAY
                      ///
                      TransactionDateCheckbox(
                        title: 'Today',
                        isActive: activeDateEnum == ActiveDate.today,
                        onPressed: () => controller.dateCheckboxPressed(
                          ActiveDate.today,
                          context: context,
                        ),
                      ),

                      ///
                      /// OTHER DAY
                      ///
                      TransactionDateCheckbox(
                        title: activeDateEnum == ActiveDate.otherDay && date != null ? getFormattedDate(date) : 'Other day',
                        isActive: activeDateEnum == ActiveDate.otherDay,
                        onPressed: () => controller.dateCheckboxPressed(
                          ActiveDate.otherDay,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// NOTE TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    autofocus: false,
                    controller: controller.noteTextEditingController,
                    labelText: 'Additional details',
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// ADD TRANSACTION BUTTON
                ///
                FilledButton(
                  onPressed: validated
                      ? () async {
                          await controller.addTransaction();
                          widget.onTransactionUpdated();
                          Navigator.of(context).pop();
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      28,
                      24,
                      MediaQuery.paddingOf(context).bottom + 12,
                    ),
                    backgroundColor: chosenCategory?.color,
                    foregroundColor: context.colors.listTileBackground,
                    disabledBackgroundColor: context.colors.buttonBackground,
                    disabledForegroundColor: context.colors.listTileBackground,
                  ),
                  child: Text(
                    widget.passedTransaction != null ? 'Update transaction'.toUpperCase() : 'Add transaction'.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
