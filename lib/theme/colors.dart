import 'package:flutter/material.dart';

abstract class TroskoColors {
  static const black = Color(0xFF121C2B);

  static const grey = Color(0xFFE4E6ED);
  static const lightGrey = Color(0xFFEDEDF4);
  static const lighterGrey = Color(0xFFF9F9FF);

  static const dark = Color(0xFF1D2024);
  static const lightDark = Color(0xFF282A2F);
  static const lighterDark = Color(0xFF2D2F34);

  static const blueLight = Color(0xFFCFD7E5);
  static const blueDark = Color(0xFF7A82AB);
  static const red = Color(0xFFE0777D);
}

class TroskoColorsExtension extends ThemeExtension<TroskoColorsExtension> {
  final Color text;
  final Color icon;
  final Color buttonPrimary;
  final Color delete;
  final Color listTileBackground;
  final Color buttonBackground;
  final Color scaffoldBackground;
  final Color disabledText;
  final Color disabledBackground;

  TroskoColorsExtension({
    required this.text,
    required this.icon,
    required this.buttonPrimary,
    required this.delete,
    required this.listTileBackground,
    required this.buttonBackground,
    required this.scaffoldBackground,
    required this.disabledText,
    required this.disabledBackground,
  });

  @override
  ThemeExtension<TroskoColorsExtension> copyWith({
    Color? text,
    Color? icon,
    Color? buttonPrimary,
    Color? delete,
    Color? listTileBackground,
    Color? buttonBackground,
    Color? scaffoldBackground,
    Color? disabledText,
    Color? disabledBackground,
  }) => TroskoColorsExtension(
    text: text ?? this.text,
    icon: icon ?? this.icon,
    buttonPrimary: buttonPrimary ?? this.buttonPrimary,
    delete: delete ?? this.delete,
    listTileBackground: listTileBackground ?? this.listTileBackground,
    buttonBackground: buttonBackground ?? this.buttonBackground,
    scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
    disabledText: disabledText ?? this.disabledText,
    disabledBackground: disabledBackground ?? this.disabledBackground,
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
      icon: Color.lerp(icon, other.icon, t)!,
      buttonPrimary: Color.lerp(buttonPrimary, other.buttonPrimary, t)!,
      delete: Color.lerp(delete, other.delete, t)!,
      listTileBackground: Color.lerp(listTileBackground, other.listTileBackground, t)!,
      buttonBackground: Color.lerp(buttonBackground, other.buttonBackground, t)!,
      scaffoldBackground: Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      disabledBackground: Color.lerp(disabledBackground, other.disabledBackground, t)!,
    );
  }
}
