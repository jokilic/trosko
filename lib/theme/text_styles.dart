import 'package:flutter/material.dart';

abstract class TroskoTextStyles {
  static const appBarTitle = TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
}

class TroskoTextThemesExtension extends ThemeExtension<TroskoTextThemesExtension> {
  final TextStyle appBarTitle;

  const TroskoTextThemesExtension({
    required this.appBarTitle,
  });

  @override
  ThemeExtension<TroskoTextThemesExtension> copyWith({
    TextStyle? appBarTitle,
  }) => TroskoTextThemesExtension(
    appBarTitle: appBarTitle ?? this.appBarTitle,
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
    );
  }
}
