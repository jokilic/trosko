import 'package:flutter/material.dart';

abstract class TroskoColors {
  static const black = Color(0xFF121C2B);

  static const grey = Color(0xFFE4E6ED);
  static const lightGrey = Color(0xFFEDEDF4);
  static const lighterGrey = Color(0xFFF9F9FF);

  static const dark = Color(0xFF1D2024);
  static const lightDark = Color(0xFF282A2F);
  static const lighterDark = Color(0xFF2D2F34);

  static const lightBlue = Color(0xFFCFD7E5);
  static const purple = Color(0xFF2F3061);
  static const red = Color(0xFFE0777D);
}

class TroskoColorsExtension extends ThemeExtension<TroskoColorsExtension> {
  final Color text;
  final Color buttonPrimary;
  final Color chipPrimary;
  final Color delete;
  final Color listTileBackground;
  final Color buttonBackground;
  final Color scaffoldBackground;

  TroskoColorsExtension({
    required this.text,
    required this.buttonPrimary,
    required this.chipPrimary,
    required this.delete,
    required this.listTileBackground,
    required this.buttonBackground,
    required this.scaffoldBackground,
  });

  @override
  ThemeExtension<TroskoColorsExtension> copyWith({
    Color? text,
    Color? buttonPrimary,
    Color? chipPrimary,
    Color? delete,
    Color? listTileBackground,
    Color? buttonBackground,
    Color? scaffoldBackground,
  }) => TroskoColorsExtension(
    text: text ?? this.text,
    buttonPrimary: buttonPrimary ?? this.buttonPrimary,
    chipPrimary: chipPrimary ?? this.chipPrimary,
    delete: delete ?? this.delete,
    listTileBackground: listTileBackground ?? this.listTileBackground,
    buttonBackground: buttonBackground ?? this.buttonBackground,
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
      text: Color.lerp(text, other.text, t)!,
      buttonPrimary: Color.lerp(buttonPrimary, other.buttonPrimary, t)!,
      chipPrimary: Color.lerp(chipPrimary, other.chipPrimary, t)!,
      delete: Color.lerp(delete, other.delete, t)!,
      listTileBackground: Color.lerp(listTileBackground, other.listTileBackground, t)!,
      buttonBackground: Color.lerp(buttonBackground, other.buttonBackground, t)!,
      scaffoldBackground: Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
    );
  }
}
