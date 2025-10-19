import 'package:flutter/material.dart';

abstract class TroskoColors {
  static const black = Color(0xFF121C2B);

  static const grey = Color(0xFFE4E6ED);
  static const lightGrey = Color(0xFFEDEDF4);
  static const lighterGrey = Color(0xFFF9F9FF);

  static const dark = Color(0xFF1D2024);
  static const lightDark = Color(0xFF282A2F);
  static const lighterDark = Color(0xFF2D2F34);

  static const green = Color(0xFF57CC99);
  static const red = Color(0xFFE0777D);
  static const blue = Color(0xFF90BEDE);
  static const darkBlue = Color(0xFF275DAD);
  static const purple = Color(0xFF947BD3);
  static const yellow = Color(0xFFF0C987);
  static const pink = Color(0xFFFAB2EA);
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
  final Color borderColor;

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
    required this.borderColor,
  });

  @override
  ThemeExtension<TroskoColorsExtension> copyWith({
    Color? text,
    Color? icon,
    Color? buttonPrimary,
    Color? delete,
    Color? listTileBackground,
    Color? buttonBackground,
    Color? filledButtonBackground,
    Color? scaffoldBackground,
    Color? disabledText,
    Color? disabledBackground,
    Color? borderColor,
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
    borderColor: borderColor ?? this.borderColor,
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
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}
