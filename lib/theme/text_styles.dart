import 'package:flutter/material.dart';

abstract class TroskoTextStyles {
  static const homeTopTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  static const button = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 24,
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

  static const transactionAmountTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static const transactionAmountCurrentValue = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  static const transactionAmountNumber = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
}

class TroskoTextThemesExtension extends ThemeExtension<TroskoTextThemesExtension> {
  final TextStyle homeTopTitle;
  final TextStyle button;
  final TextStyle homeTransactionTitle;
  final TextStyle homeTransactionSubtitle;
  final TextStyle homeTransactionValue;
  final TextStyle transactionAmountTitle;
  final TextStyle transactionAmountCurrentValue;
  final TextStyle transactionAmountNumber;

  const TroskoTextThemesExtension({
    required this.homeTopTitle,
    required this.button,
    required this.homeTransactionTitle,
    required this.homeTransactionSubtitle,
    required this.homeTransactionValue,
    required this.transactionAmountTitle,
    required this.transactionAmountCurrentValue,
    required this.transactionAmountNumber,
  });

  @override
  ThemeExtension<TroskoTextThemesExtension> copyWith({
    TextStyle? homeTopTitle,
    TextStyle? button,
    TextStyle? homeTransactionTitle,
    TextStyle? homeTransactionSubtitle,
    TextStyle? homeTransactionValue,
    TextStyle? transactionAmountTitle,
    TextStyle? transactionAmountCurrentValue,
    TextStyle? transactionAmountNumber,
  }) => TroskoTextThemesExtension(
    homeTopTitle: homeTopTitle ?? this.homeTopTitle,
    button: button ?? this.button,
    homeTransactionTitle: homeTransactionTitle ?? this.homeTransactionTitle,
    homeTransactionSubtitle: homeTransactionSubtitle ?? this.homeTransactionSubtitle,
    homeTransactionValue: homeTransactionValue ?? this.homeTransactionValue,
    transactionAmountTitle: transactionAmountTitle ?? this.transactionAmountTitle,
    transactionAmountCurrentValue: transactionAmountCurrentValue ?? this.transactionAmountCurrentValue,
    transactionAmountNumber: transactionAmountNumber ?? this.transactionAmountNumber,
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
      homeTopTitle: TextStyle.lerp(homeTopTitle, other.homeTopTitle, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      homeTransactionTitle: TextStyle.lerp(homeTransactionTitle, other.homeTransactionTitle, t)!,
      homeTransactionSubtitle: TextStyle.lerp(homeTransactionSubtitle, other.homeTransactionSubtitle, t)!,
      homeTransactionValue: TextStyle.lerp(homeTransactionValue, other.homeTransactionValue, t)!,
      transactionAmountTitle: TextStyle.lerp(transactionAmountTitle, other.transactionAmountTitle, t)!,
      transactionAmountCurrentValue: TextStyle.lerp(transactionAmountCurrentValue, other.transactionAmountCurrentValue, t)!,
      transactionAmountNumber: TextStyle.lerp(transactionAmountNumber, other.transactionAmountNumber, t)!,
    );
  }
}
