import 'package:flutter/material.dart';

abstract class TroskoTextStyles {
  static const appBarTitle = TextStyle(
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
}

class TroskoTextThemesExtension extends ThemeExtension<TroskoTextThemesExtension> {
  final TextStyle appBarTitle;
  final TextStyle button;
  final TextStyle homeTransactionTitle;
  final TextStyle homeTransactionSubtitle;

  const TroskoTextThemesExtension({
    required this.appBarTitle,
    required this.button,
    required this.homeTransactionTitle,
    required this.homeTransactionSubtitle,
  });

  @override
  ThemeExtension<TroskoTextThemesExtension> copyWith({
    TextStyle? appBarTitle,
    TextStyle? button,
    TextStyle? homeTransactionTitle,
    TextStyle? homeTransactionSubtitle,
  }) => TroskoTextThemesExtension(
    appBarTitle: appBarTitle ?? this.appBarTitle,
    button: button ?? this.button,
    homeTransactionTitle: homeTransactionTitle ?? this.homeTransactionTitle,
    homeTransactionSubtitle: homeTransactionSubtitle ?? this.homeTransactionSubtitle,
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
      appBarTitle: TextStyle.lerp(appBarTitle, other.appBarTitle, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      homeTransactionTitle: TextStyle.lerp(homeTransactionTitle, other.homeTransactionTitle, t)!,
      homeTransactionSubtitle: TextStyle.lerp(homeTransactionSubtitle, other.homeTransactionSubtitle, t)!,
    );
  }
}
