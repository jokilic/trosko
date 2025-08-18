import 'package:flutter/material.dart';

abstract class TroskoColors {
  static const white = Color(0xFFF2FDFF);
  static const black = Color(0xFF101935);
  static const purple = Color(0xFF564787);
  static const pink = Color(0xFFF9DAD0);
  static const green = Color(0xFF417B5A);
  static const blue = Color(0xFF4A5899);
  static const lightGreen = Color(0xFF9AD4D6);
}

class TroskoColorsExtension extends ThemeExtension<TroskoColorsExtension> {
  final Color primary;
  final Color background;
  final Color text;
  final Color secondary;

  TroskoColorsExtension({
    required this.primary,
    required this.background,
    required this.text,
    required this.secondary,
  });

  @override
  ThemeExtension<TroskoColorsExtension> copyWith({
    Color? primary,
    Color? background,
    Color? text,
    Color? secondary,
  }) => TroskoColorsExtension(
    primary: primary ?? this.primary,
    background: background ?? this.background,
    text: text ?? this.text,
    secondary: secondary ?? this.secondary,
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
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }
}
