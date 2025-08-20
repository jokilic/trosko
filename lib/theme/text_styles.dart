import 'package:flutter/material.dart';

abstract class TroskoTextStyles {
  static const button = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const homeTopTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  static const homeTransactionTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const homeTransactionSubtitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const homeTransactionValue = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const transactionTopTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  static const transactionAmountTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 28,
    fontWeight: FontWeight.w700,
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

  static const transactionNameTextField = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const transactionCategoryName = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
}

class TroskoTextThemesExtension extends ThemeExtension<TroskoTextThemesExtension> {
  final TextStyle button;
  final TextStyle homeTopTitle;
  final TextStyle homeTransactionTitle;
  final TextStyle homeTransactionSubtitle;
  final TextStyle homeTransactionValue;
  final TextStyle transactionTopTitle;
  final TextStyle transactionAmountTitle;
  final TextStyle transactionAmountCurrentValue;
  final TextStyle transactionAmountNumber;
  final TextStyle transactionNameTextField;
  final TextStyle transactionCategoryName;

  const TroskoTextThemesExtension({
    required this.button,
    required this.homeTopTitle,
    required this.homeTransactionTitle,
    required this.homeTransactionSubtitle,
    required this.homeTransactionValue,
    required this.transactionTopTitle,
    required this.transactionAmountTitle,
    required this.transactionAmountCurrentValue,
    required this.transactionAmountNumber,
    required this.transactionNameTextField,
    required this.transactionCategoryName,
  });

  @override
  ThemeExtension<TroskoTextThemesExtension> copyWith({
    TextStyle? button,
    TextStyle? homeTopTitle,
    TextStyle? homeTransactionTitle,
    TextStyle? homeTransactionSubtitle,
    TextStyle? homeTransactionValue,
    TextStyle? transactionTopTitle,
    TextStyle? transactionAmountTitle,
    TextStyle? transactionAmountCurrentValue,
    TextStyle? transactionAmountNumber,
    TextStyle? transactionNameTextField,
    TextStyle? transactionCategoryName,
  }) => TroskoTextThemesExtension(
    button: button ?? this.button,
    homeTopTitle: homeTopTitle ?? this.homeTopTitle,
    homeTransactionTitle: homeTransactionTitle ?? this.homeTransactionTitle,
    homeTransactionSubtitle: homeTransactionSubtitle ?? this.homeTransactionSubtitle,
    homeTransactionValue: homeTransactionValue ?? this.homeTransactionValue,
    transactionTopTitle: transactionTopTitle ?? this.transactionTopTitle,
    transactionAmountTitle: transactionAmountTitle ?? this.transactionAmountTitle,
    transactionAmountCurrentValue: transactionAmountCurrentValue ?? this.transactionAmountCurrentValue,
    transactionAmountNumber: transactionAmountNumber ?? this.transactionAmountNumber,
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
      homeTopTitle: TextStyle.lerp(homeTopTitle, other.homeTopTitle, t)!,
      homeTransactionTitle: TextStyle.lerp(homeTransactionTitle, other.homeTransactionTitle, t)!,
      homeTransactionSubtitle: TextStyle.lerp(homeTransactionSubtitle, other.homeTransactionSubtitle, t)!,
      homeTransactionValue: TextStyle.lerp(homeTransactionValue, other.homeTransactionValue, t)!,
      transactionTopTitle: TextStyle.lerp(transactionTopTitle, other.transactionTopTitle, t)!,
      transactionAmountTitle: TextStyle.lerp(transactionAmountTitle, other.transactionAmountTitle, t)!,
      transactionAmountCurrentValue: TextStyle.lerp(transactionAmountCurrentValue, other.transactionAmountCurrentValue, t)!,
      transactionAmountNumber: TextStyle.lerp(transactionAmountNumber, other.transactionAmountNumber, t)!,
      transactionNameTextField: TextStyle.lerp(transactionNameTextField, other.transactionNameTextField, t)!,
      transactionCategoryName: TextStyle.lerp(transactionCategoryName, other.transactionCategoryName, t)!,
    );
  }
}
