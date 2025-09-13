import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../constants/enums.dart';
import '../../models/category/category.dart';
import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class TransactionController
    extends
        ValueNotifier<
          ({Category? category, int? amountCents, DateTime? transactionDate, bool nameValid, bool amountValid, bool categoryValid, bool dateValid, ActiveDate activeDateEnum})
        >
    implements Disposable {
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
         transactionDate: null,
         nameValid: false,
         amountValid: false,
         categoryValid: false,
         dateValid: false,
         activeDateEnum: ActiveDate.today,
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
      amountCents: passedTransaction?.amountCents,
      transactionDate: passedTransaction?.createdAt ?? DateTime.now(),
      nameValid: passedTransaction?.name.isNotEmpty ?? false,
      amountValid: (passedTransaction?.amountCents ?? 0) > 0,
      categoryValid: category != null,
      dateValid: true,
      activeDateEnum: passedTransaction?.createdAt != null ? ActiveDate.otherDay : ActiveDate.today,
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

  /// Triggered when the user changes date
  void dateChanged(DateTime newDate) => updateState(
    transactionDate: newDate,
    dateValid: true,
  );

  /// Triggered when the user presses date checkbox
  void dateCheckboxPressed(
    ActiveDate newActiveDateEnum, {
    required BuildContext context,
  }) {
    if (newActiveDateEnum == ActiveDate.today) {
      dateChanged(DateTime.now());
    }

    if (newActiveDateEnum == ActiveDate.otherDay) {
      openCalendar(context);
    }

    updateState(
      activeDateEnum: newActiveDateEnum,
    );
  }

  /// Opens calendar
  void openCalendar(BuildContext context) => showCalendarDatePicker2Dialog(
    context: context,
    onValueChanged: (newValue) async {
      final chosenDate = newValue.first;

      if (chosenDate != null) {
        Navigator.of(context).pop();

        dateChanged(chosenDate);
        updateState(
          activeDateEnum: ActiveDate.otherDay,
        );
      }
    },
    config: CalendarDatePicker2WithActionButtonsConfig(
      // weekdayLabelTextStyle: context.textStyles.teamTransferTeam,
      // controlsTextStyle: context.textStyles.teamTransferTeam,
      // dayTextStyle: context.textStyles.calendarDayInactive,
      // todayTextStyle: context.textStyles.calendarDayActive,
      // selectedDayTextStyle: context.textStyles.calendarDayActive.copyWith(
      //   color: context.colors.primaryBackground,
      // ),
      // selectedMonthTextStyle: context.textStyles.calendarDayActive.copyWith(
      //   color: context.colors.primaryBackground,
      // ),
      // selectedYearTextStyle: context.textStyles.calendarDayActive.copyWith(
      //   color: context.colors.primaryBackground,
      // ),
      // selectedDayHighlightColor: context.colors.accentStrong,
      // daySplashColor: context.colors.accentStrong,
      firstDayOfWeek: 1,
      useAbbrLabelForMonthModePicker: true,
      // cancelButton: BalunButton(
      //   child: Text(
      //     'fixturesCalendarCancel'.tr().toUpperCase(),
      //     style: context.textStyles.calendarDayInactive,
      //   ),
      // ),
      // okButton: BalunButton(
      //   child: Text(
      //     'fixturesCalendarGo'.tr().toUpperCase(),
      //     style: context.textStyles.teamTransferTeam,
      //   ),
      // ),
      // lastMonthIcon: const BalunImage(
      //   imageUrl: BalunIcons.back,
      //   height: 20,
      //   width: 20,
      // ),
      // nextMonthIcon: Transform.rotate(
      //   angle: pi,
      //   child: const BalunImage(
      //     imageUrl: BalunIcons.back,
      //     height: 20,
      //     width: 20,
      //   ),
      // ),
    ),
    borderRadius: BorderRadius.circular(8),
    // dialogBackgroundColor: context.colors.accentLight,
    dialogSize: const Size(325, 400),
  );

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
      createdAt: value.transactionDate ?? DateTime.now(),
    );

    /// User modified transaction
    if (passedTransaction != null) {
      await hive.updateTransaction(
        newTransaction: newTransaction,
      );
    }
    /// User created new transaction
    else {
      await hive.writeTransaction(
        newTransaction: newTransaction,
      );
    }
  }

  /// Triggered when the user deletes transaction
  Future<void> deleteTransaction() async {
    if (passedTransaction != null) {
      await hive.deleteTransaction(
        transaction: passedTransaction!,
      );
    }
  }

  /// Updates `state`
  void updateState({
    Category? category,
    int? amountCents,
    DateTime? transactionDate,
    bool? nameValid,
    bool? amountValid,
    bool? categoryValid,
    bool? dateValid,
    ActiveDate? activeDateEnum,
  }) => value = (
    category: category ?? value.category,
    amountCents: amountCents ?? value.amountCents,
    transactionDate: transactionDate ?? value.transactionDate,
    nameValid: nameValid ?? value.nameValid,
    amountValid: amountValid ?? value.amountValid,
    categoryValid: categoryValid ?? value.categoryValid,
    dateValid: dateValid ?? value.dateValid,
    activeDateEnum: activeDateEnum ?? value.activeDateEnum,
  );
}
