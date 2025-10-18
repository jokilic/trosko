import 'package:flutter/material.dart';

abstract class TroskoTextStyles {
  static const button = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  static const appBarTitleSmall = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const appBarTitleBig = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const appBarSubtitleBig = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const homeFloatingActionButton = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  );

  static const homeMonthChip = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 0,
  );

  static const homeCategoryTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const homeTransactionTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const homeTransactionTime = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const homeTransactionNote = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const homeTransactionValue = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const homeTransactionEuro = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const homeTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const homeTitleBold = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const homeTitleEuro = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const transactionAmountCurrentValue = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );

  static const transactionAmountNumber = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static const textField = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const transactionCategoryName = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const transactionTimeActive = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const transactionTimeInactive = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const transactionDateInactive = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const transactionDateActive = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const categoryName = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const categoryIcon = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
}

class TroskoTextThemesExtension extends ThemeExtension<TroskoTextThemesExtension> {
  final TextStyle button;
  final TextStyle appBarTitleSmall;
  final TextStyle appBarTitleBig;
  final TextStyle appBarSubtitleBig;
  final TextStyle homeFloatingActionButton;
  final TextStyle homeMonthChip;
  final TextStyle homeCategoryTitle;
  final TextStyle homeTransactionTitle;
  final TextStyle homeTransactionTime;
  final TextStyle homeTransactionNote;
  final TextStyle homeTransactionValue;
  final TextStyle homeTransactionEuro;
  final TextStyle homeTitle;
  final TextStyle homeTitleBold;
  final TextStyle homeTitleEuro;
  final TextStyle transactionAmountCurrentValue;
  final TextStyle transactionAmountNumber;
  final TextStyle textField;
  final TextStyle transactionCategoryName;
  final TextStyle transactionTimeActive;
  final TextStyle transactionTimeInactive;
  final TextStyle transactionDateInactive;
  final TextStyle transactionDateActive;
  final TextStyle categoryName;
  final TextStyle categoryIcon;

  const TroskoTextThemesExtension({
    required this.button,
    required this.appBarTitleSmall,
    required this.appBarTitleBig,
    required this.appBarSubtitleBig,
    required this.homeFloatingActionButton,
    required this.homeMonthChip,
    required this.homeCategoryTitle,
    required this.homeTransactionTitle,
    required this.homeTransactionTime,
    required this.homeTransactionNote,
    required this.homeTransactionValue,
    required this.homeTransactionEuro,
    required this.homeTitle,
    required this.homeTitleBold,
    required this.homeTitleEuro,
    required this.transactionAmountCurrentValue,
    required this.transactionAmountNumber,
    required this.textField,
    required this.transactionCategoryName,
    required this.transactionTimeActive,
    required this.transactionTimeInactive,
    required this.transactionDateInactive,
    required this.transactionDateActive,
    required this.categoryName,
    required this.categoryIcon,
  });

  @override
  ThemeExtension<TroskoTextThemesExtension> copyWith({
    TextStyle? button,
    TextStyle? appBarTitleSmall,
    TextStyle? appBarTitleBig,
    TextStyle? appBarSubtitleBig,
    TextStyle? homeFloatingActionButton,
    TextStyle? homeMonthChip,
    TextStyle? homeCategoryTitle,
    TextStyle? homeTransactionTitle,
    TextStyle? homeTransactionTime,
    TextStyle? homeTransactionNote,
    TextStyle? homeTransactionValue,
    TextStyle? homeTransactionEuro,
    TextStyle? homeTitle,
    TextStyle? homeTitleBold,
    TextStyle? homeTitleEuro,
    TextStyle? transactionAmountCurrentValue,
    TextStyle? transactionAmountNumber,
    TextStyle? textField,
    TextStyle? transactionCategoryName,
    TextStyle? transactionTimeActive,
    TextStyle? transactionTimeInactive,
    TextStyle? transactionDateInactive,
    TextStyle? transactionDateActive,
    TextStyle? categoryName,
    TextStyle? categoryIcon,
  }) => TroskoTextThemesExtension(
    button: button ?? this.button,
    appBarTitleSmall: appBarTitleSmall ?? this.appBarTitleSmall,
    appBarTitleBig: appBarTitleBig ?? this.appBarTitleBig,
    appBarSubtitleBig: appBarSubtitleBig ?? this.appBarSubtitleBig,
    homeFloatingActionButton: homeFloatingActionButton ?? this.homeFloatingActionButton,
    homeMonthChip: homeMonthChip ?? this.homeMonthChip,
    homeCategoryTitle: homeCategoryTitle ?? this.homeCategoryTitle,
    homeTransactionTitle: homeTransactionTitle ?? this.homeTransactionTitle,
    homeTransactionTime: homeTransactionTime ?? this.homeTransactionTime,
    homeTransactionNote: homeTransactionNote ?? this.homeTransactionNote,
    homeTransactionValue: homeTransactionValue ?? this.homeTransactionValue,
    homeTransactionEuro: homeTransactionEuro ?? this.homeTransactionEuro,
    homeTitle: homeTitle ?? this.homeTitle,
    homeTitleBold: homeTitleBold ?? this.homeTitleBold,
    homeTitleEuro: homeTitleEuro ?? this.homeTitleEuro,
    transactionAmountCurrentValue: transactionAmountCurrentValue ?? this.transactionAmountCurrentValue,
    transactionAmountNumber: transactionAmountNumber ?? this.transactionAmountNumber,
    textField: textField ?? this.textField,
    transactionCategoryName: transactionCategoryName ?? this.transactionCategoryName,
    transactionTimeActive: transactionTimeActive ?? this.transactionTimeActive,
    transactionTimeInactive: transactionTimeInactive ?? this.transactionTimeInactive,
    transactionDateInactive: transactionDateInactive ?? this.transactionDateInactive,
    transactionDateActive: transactionDateActive ?? this.transactionDateActive,
    categoryName: categoryName ?? this.categoryName,
    categoryIcon: categoryIcon ?? this.categoryIcon,
  );

  @override
  ThemeExtension<TroskoTextThemesExtension> lerp(
    covariant ThemeExtension<TroskoTextThemesExtension>? other,
    double t,
  ) {
    if (other is! TroskoTextThemesExtension) {
      return this;
    }

    return TroskoTextThemesExtension(
      button: TextStyle.lerp(button, other.button, t)!,
      appBarTitleSmall: TextStyle.lerp(appBarTitleSmall, other.appBarTitleSmall, t)!,
      appBarTitleBig: TextStyle.lerp(appBarTitleBig, other.appBarTitleBig, t)!,
      appBarSubtitleBig: TextStyle.lerp(appBarSubtitleBig, other.appBarSubtitleBig, t)!,
      homeFloatingActionButton: TextStyle.lerp(homeFloatingActionButton, other.homeFloatingActionButton, t)!,
      homeMonthChip: TextStyle.lerp(homeMonthChip, other.homeMonthChip, t)!,
      homeCategoryTitle: TextStyle.lerp(homeCategoryTitle, other.homeCategoryTitle, t)!,
      homeTransactionTitle: TextStyle.lerp(homeTransactionTitle, other.homeTransactionTitle, t)!,
      homeTransactionTime: TextStyle.lerp(homeTransactionTime, other.homeTransactionTime, t)!,
      homeTransactionNote: TextStyle.lerp(homeTransactionNote, other.homeTransactionNote, t)!,
      homeTransactionValue: TextStyle.lerp(homeTransactionValue, other.homeTransactionValue, t)!,
      homeTransactionEuro: TextStyle.lerp(homeTransactionEuro, other.homeTransactionEuro, t)!,
      homeTitle: TextStyle.lerp(homeTitle, other.homeTitle, t)!,
      homeTitleBold: TextStyle.lerp(homeTitleBold, other.homeTitleBold, t)!,
      homeTitleEuro: TextStyle.lerp(homeTitleEuro, other.homeTitleEuro, t)!,
      transactionAmountCurrentValue: TextStyle.lerp(transactionAmountCurrentValue, other.transactionAmountCurrentValue, t)!,
      transactionAmountNumber: TextStyle.lerp(transactionAmountNumber, other.transactionAmountNumber, t)!,
      textField: TextStyle.lerp(textField, other.textField, t)!,
      transactionCategoryName: TextStyle.lerp(transactionCategoryName, other.transactionCategoryName, t)!,
      transactionTimeActive: TextStyle.lerp(transactionTimeActive, other.transactionTimeActive, t)!,
      transactionTimeInactive: TextStyle.lerp(transactionTimeInactive, other.transactionTimeInactive, t)!,
      transactionDateInactive: TextStyle.lerp(transactionDateInactive, other.transactionDateInactive, t)!,
      transactionDateActive: TextStyle.lerp(transactionDateActive, other.transactionDateActive, t)!,
      categoryName: TextStyle.lerp(categoryName, other.categoryName, t)!,
      categoryIcon: TextStyle.lerp(categoryIcon, other.categoryIcon, t)!,
    );
  }
}
