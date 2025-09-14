import 'package:flutter/material.dart';

abstract class TroskoTextStyles {
  static const button = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
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
    fontWeight: FontWeight.w700,
  );

  static const homeTopTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 40,
    fontWeight: FontWeight.w700,
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
    fontWeight: FontWeight.w700,
  );

  static const homeTransactionSubtitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const homeTransactionTimeAgo = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const homeTransactionValue = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const homeTransactionEuro = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const homeTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const homeTitleEuro = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const transactionAmountCurrentValue = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static const transactionAmountNumber = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const transactionDateText = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const transactionNameTextField = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const transactionCategoryName = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}

class TroskoTextThemesExtension extends ThemeExtension<TroskoTextThemesExtension> {
  final TextStyle button;
  final TextStyle appBarTitleSmall;
  final TextStyle appBarTitleBig;
  final TextStyle appBarSubtitleBig;
  final TextStyle homeFloatingActionButton;
  final TextStyle homeTopTitle;
  final TextStyle homeMonthChip;
  final TextStyle homeCategoryTitle;
  final TextStyle homeTransactionTitle;
  final TextStyle homeTransactionSubtitle;
  final TextStyle homeTransactionTimeAgo;
  final TextStyle homeTransactionValue;
  final TextStyle homeTransactionEuro;
  final TextStyle homeTitle;
  final TextStyle homeTitleEuro;
  final TextStyle transactionAmountCurrentValue;
  final TextStyle transactionAmountNumber;
  final TextStyle transactionDateText;
  final TextStyle transactionNameTextField;
  final TextStyle transactionCategoryName;

  const TroskoTextThemesExtension({
    required this.button,
    required this.appBarTitleSmall,
    required this.appBarTitleBig,
    required this.appBarSubtitleBig,
    required this.homeFloatingActionButton,
    required this.homeTopTitle,
    required this.homeMonthChip,
    required this.homeCategoryTitle,
    required this.homeTransactionTitle,
    required this.homeTransactionSubtitle,
    required this.homeTransactionTimeAgo,
    required this.homeTransactionValue,
    required this.homeTransactionEuro,
    required this.homeTitle,
    required this.homeTitleEuro,
    required this.transactionAmountCurrentValue,
    required this.transactionAmountNumber,
    required this.transactionDateText,
    required this.transactionNameTextField,
    required this.transactionCategoryName,
  });

  @override
  ThemeExtension<TroskoTextThemesExtension> copyWith({
    TextStyle? button,
    TextStyle? appBarTitleSmall,
    TextStyle? appBarTitleBig,
    TextStyle? appBarSubtitleBig,
    TextStyle? homeFloatingActionButton,
    TextStyle? homeTopTitle,
    TextStyle? homeMonthChip,
    TextStyle? homeCategoryTitle,
    TextStyle? homeTransactionTitle,
    TextStyle? homeTransactionSubtitle,
    TextStyle? homeTransactionTimeAgo,
    TextStyle? homeTransactionValue,
    TextStyle? homeTransactionEuro,
    TextStyle? homeTitle,
    TextStyle? homeTitleEuro,
    TextStyle? transactionAmountCurrentValue,
    TextStyle? transactionAmountNumber,
    TextStyle? transactionDateText,
    TextStyle? transactionNameTextField,
    TextStyle? transactionCategoryName,
  }) => TroskoTextThemesExtension(
    button: button ?? this.button,
    appBarTitleSmall: appBarTitleSmall ?? this.appBarTitleSmall,
    appBarTitleBig: appBarTitleBig ?? this.appBarTitleBig,
    appBarSubtitleBig: appBarSubtitleBig ?? this.appBarSubtitleBig,
    homeFloatingActionButton: homeFloatingActionButton ?? this.homeFloatingActionButton,
    homeTopTitle: homeTopTitle ?? this.homeTopTitle,
    homeMonthChip: homeMonthChip ?? this.homeMonthChip,
    homeCategoryTitle: homeCategoryTitle ?? this.homeCategoryTitle,
    homeTransactionTitle: homeTransactionTitle ?? this.homeTransactionTitle,
    homeTransactionSubtitle: homeTransactionSubtitle ?? this.homeTransactionSubtitle,
    homeTransactionTimeAgo: homeTransactionTimeAgo ?? this.homeTransactionTimeAgo,
    homeTransactionValue: homeTransactionValue ?? this.homeTransactionValue,
    homeTransactionEuro: homeTransactionEuro ?? this.homeTransactionEuro,
    homeTitle: homeTitle ?? this.homeTitle,
    homeTitleEuro: homeTitleEuro ?? this.homeTitleEuro,
    transactionAmountCurrentValue: transactionAmountCurrentValue ?? this.transactionAmountCurrentValue,
    transactionAmountNumber: transactionAmountNumber ?? this.transactionAmountNumber,
    transactionDateText: transactionDateText ?? this.transactionDateText,
    transactionNameTextField: transactionNameTextField ?? this.transactionNameTextField,
    transactionCategoryName: transactionCategoryName ?? this.transactionCategoryName,
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
      homeTopTitle: TextStyle.lerp(homeTopTitle, other.homeTopTitle, t)!,
      homeMonthChip: TextStyle.lerp(homeMonthChip, other.homeMonthChip, t)!,
      homeCategoryTitle: TextStyle.lerp(homeCategoryTitle, other.homeCategoryTitle, t)!,
      homeTransactionTitle: TextStyle.lerp(homeTransactionTitle, other.homeTransactionTitle, t)!,
      homeTransactionSubtitle: TextStyle.lerp(homeTransactionSubtitle, other.homeTransactionSubtitle, t)!,
      homeTransactionTimeAgo: TextStyle.lerp(homeTransactionTimeAgo, other.homeTransactionTimeAgo, t)!,
      homeTransactionValue: TextStyle.lerp(homeTransactionValue, other.homeTransactionValue, t)!,
      homeTransactionEuro: TextStyle.lerp(homeTransactionEuro, other.homeTransactionEuro, t)!,
      homeTitle: TextStyle.lerp(homeTitle, other.homeTitle, t)!,
      homeTitleEuro: TextStyle.lerp(homeTitleEuro, other.homeTitleEuro, t)!,
      transactionAmountCurrentValue: TextStyle.lerp(transactionAmountCurrentValue, other.transactionAmountCurrentValue, t)!,
      transactionAmountNumber: TextStyle.lerp(transactionAmountNumber, other.transactionAmountNumber, t)!,
      transactionDateText: TextStyle.lerp(transactionDateText, other.transactionDateText, t)!,
      transactionNameTextField: TextStyle.lerp(transactionNameTextField, other.transactionNameTextField, t)!,
      transactionCategoryName: TextStyle.lerp(transactionCategoryName, other.transactionCategoryName, t)!,
    );
  }
}
