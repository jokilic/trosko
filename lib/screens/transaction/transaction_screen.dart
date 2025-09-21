import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/category/category.dart';
import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/colors.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import '../../util/icons.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_text_field.dart';
import 'transaction_controller.dart';
import 'widgets/transaction_amount_widget.dart';
import 'widgets/transaction_category.dart';

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

    final activeCategory = state.category;
    final chosenDateTime = state.transactionDateTime;

    final dateEditMode = state.dateEditMode;
    final timeEditMode = state.timeEditMode;

    final validated = state.nameValid && state.amountValid && state.categoryValid;

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
                highlightColor: context.colors.buttonBackground,
              ),
              icon: PhosphorIcon(
                PhosphorIcons.arrowLeft(
                  PhosphorIconsStyle.bold,
                ),
                color: context.colors.text,
                size: 28,
              ),
            ),
            actionWidgets: [
              if (widget.passedTransaction != null)
                IconButton(
                  onPressed: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );
                    await controller.deleteTransaction();
                    widget.onTransactionUpdated();
                    Navigator.of(context).pop();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    highlightColor: context.colors.buttonBackground,
                  ),
                  icon: PhosphorIcon(
                    PhosphorIcons.trash(
                      PhosphorIconsStyle.bold,
                    ),
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
                const SizedBox(height: 4),

                ///
                /// CATEGORY TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'Category',
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// CATEGORY
                ///
                IntrinsicHeight(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        widget.categories.length,
                        (index) {
                          final category = widget.categories[index];

                          return TransactionCategory(
                            onPressed: (category) {
                              HapticFeedback.lightImpact();
                              controller.categoryChanged(category);
                            },
                            category: category,
                            color: category.color.withValues(
                              alpha: activeCategory == category ? 1 : 0.2,
                            ),
                            highlightColor: category.color.withValues(
                              alpha: activeCategory == category ? 1 : 0.2,
                            ),
                            icon: getIconFromName(
                              category.iconName,
                            )?.value,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ///
                /// TITLE & NOTE TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'Title & note',
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// TITLE TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    autofocus: false,
                    controller: controller.nameTextEditingController,
                    labelText: 'Title',
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
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
                    labelText: 'Note (not necessary)',
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// AMOUNT TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'Amount',
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

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
                /// DATE TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'Date',
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// DATE
                ///
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    controller.dateEditModeChanged();
                  },
                  highlightColor: context.colors.buttonBackground,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: dateEditMode ? context.colors.listTileBackground : null,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IgnorePointer(
                      ignoring: !dateEditMode,
                      child: ScrollDateTimePicker(
                        onChange: controller.dateChanged,
                        itemExtent: 64,
                        style: DateTimePickerStyle(
                          activeStyle: context.textStyles.transactionDateTimeActive,
                          inactiveStyle: context.textStyles.transactionDateTimeInactive,
                          disabledStyle: context.textStyles.transactionDateTimeInactive.copyWith(
                            color: context.colors.disabledText,
                          ),
                        ),
                        wheelOption: const DateTimePickerWheelOption(
                          physics: BouncingScrollPhysics(),
                        ),
                        dateOption: DateTimePickerOption(
                          dateFormat: DateFormat(
                            'E, dd MMMM yyyy',
                            'hr',
                          ),
                          minDate: DateTime(2020),
                          maxDate: DateTime(2040),
                          initialDate: chosenDateTime,
                        ),
                        centerWidget: DateTimePickerCenterWidget(
                          builder: (context, constraints, child) => Container(
                            decoration: ShapeDecoration(
                              color: context.colors.listTileBackground,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: context.colors.text,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// TIME TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'Time',
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// TIME
                ///
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    controller.timeEditModeChanged();
                  },
                  highlightColor: context.colors.buttonBackground,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: timeEditMode ? context.colors.listTileBackground : null,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IgnorePointer(
                      ignoring: !timeEditMode,
                      child: ScrollDateTimePicker(
                        onChange: controller.timeChanged,
                        itemExtent: 64,
                        style: DateTimePickerStyle(
                          activeStyle: context.textStyles.transactionDateTimeActive,
                          inactiveStyle: context.textStyles.transactionDateTimeInactive,
                          disabledStyle: context.textStyles.transactionDateTimeInactive.copyWith(
                            color: context.colors.disabledText,
                          ),
                        ),
                        wheelOption: const DateTimePickerWheelOption(
                          physics: BouncingScrollPhysics(),
                        ),
                        dateOption: DateTimePickerOption(
                          dateFormat: DateFormat(
                            'HH:mm',
                            'hr',
                          ),
                          minDate: DateTime(2010),
                          maxDate: DateTime(2040),
                          initialDate: chosenDateTime,
                        ),
                        centerWidget: DateTimePickerCenterWidget(
                          builder: (context, constraints, child) => Container(
                            decoration: ShapeDecoration(
                              color: context.colors.listTileBackground,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: context.colors.text,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: validated
              ? () async {
                  unawaited(
                    HapticFeedback.lightImpact(),
                  );
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
            backgroundColor: activeCategory?.color,
            foregroundColor: TroskoColors.lighterGrey,
            overlayColor: context.colors.buttonBackground,
            disabledBackgroundColor: context.colors.disabledBackground,
            disabledForegroundColor: context.colors.disabledText,
          ),
          child: Text(
            (widget.passedTransaction != null ? 'Update expense' : 'Add expense').toUpperCase(),
          ),
        ),
      ),
    );
  }
}
