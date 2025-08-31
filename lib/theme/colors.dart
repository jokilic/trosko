import 'package:flutter/material.dart';

abstract class TroskoColors {
  static const white = Color(0xFFF9F9FF);
  static const black = Color(0xFF121c2b);
  static const lightBlue = Color(0xFFCFD7E5);
  static const lightGrey = Color(0xFFEDEDF4);
  static const grey = Color(0xFFE4E6ED);
}

class TroskoColorsExtension extends ThemeExtension<TroskoColorsExtension> {
  final Color primary;
  final Color background;
  final Color text;
  final Color scaffoldBackground;

  TroskoColorsExtension({
    required this.primary,
    required this.background,
    required this.text,
    required this.scaffoldBackground,
  });

  @override
  ThemeExtension<TroskoColorsExtension> copyWith({
    Color? primary,
    Color? background,
    Color? text,
    Color? scaffoldBackground,
  }) => TroskoColorsExtension(
    primary: primary ?? this.primary,
    background: background ?? this.background,
    text: text ?? this.text,
    scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
  );

  @override
  ThemeExtension<TroskoColorsExtension> lerp(
    covariant ThemeExtension<TroskoColorsExtension>? other,
    double t,
  ) {
    if (other is! TroskoColorsExtension) {
      return this;
    }

    return TroskoColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      text: Color.lerp(text, other.text, t)!,
      scaffoldBackground: Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
    );
  }
}
