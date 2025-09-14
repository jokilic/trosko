import 'package:flutter/material.dart';

abstract class TroskoColors {
  static const white = Color(0xFFF9F9FF);
  static const black = Color(0xFF121C2B);
  static const grey = Color(0xFFE4E6ED);
  static const lightGrey = Color(0xFFEDEDF4);

  static const lightBlue = Color(0xFFCFD7E5);
  static const blue = Color(0xFF4C86A8);
  static const orange = Color(0xFFC17767);
  static const green = Color(0xFF4C8577);
  static const yellow = Color(0xFFE1DD8F);
  static const red = Color(0xFFE0777D);
}

class TroskoColorsExtension extends ThemeExtension<TroskoColorsExtension> {
  final Color primary;
  final Color text;
  final Color delete;
  final Color listTileBackground;
  final Color buttonBackground;
  final Color scaffoldBackground;

  TroskoColorsExtension({
    required this.primary,
    required this.text,
    required this.delete,
    required this.listTileBackground,
    required this.buttonBackground,
    required this.scaffoldBackground,
  });

  @override
  ThemeExtension<TroskoColorsExtension> copyWith({
    Color? primary,
    Color? text,
    Color? delete,
    Color? listTileBackground,
    Color? buttonBackground,
    Color? scaffoldBackground,
  }) => TroskoColorsExtension(
    primary: primary ?? this.primary,
    text: text ?? this.text,
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
      primary: Color.lerp(primary, other.primary, t)!,
      text: Color.lerp(text, other.text, t)!,
      delete: Color.lerp(delete, other.delete, t)!,
      listTileBackground: Color.lerp(listTileBackground, other.listTileBackground, t)!,
      buttonBackground: Color.lerp(buttonBackground, other.buttonBackground, t)!,
      scaffoldBackground: Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
    );
  }
}
