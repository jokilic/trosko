import 'package:flutter/material.dart';

abstract class TroskoColors {
  ///
  /// LIGHT THEME
  ///

  static const lightThemeBlackText = Color(0xFF121C2B);
  static const lightThemeWhiteBackground = Color(0xFFF9F9FF);
  static const lightThemeButtonBackground = Color(0xFFE4E6ED);
  static const lightThemeWhiteScaffold = Color(0xFFEDEDF4);
  static const lightThemeDisabledText = Color(0xFF2D2F34);
  static const lightThemeDisabledBackground = Color(0xFFE4E6ED);

  ///
  /// DARK THEME
  ///

  static const darkThemeWhiteText = Color(0xFFF9F9FF);
  static const darkThemeBlackBackground = Color(0xFF282A2F);
  static const darkThemeButtonBackground = Color(0xFF2D2F34);
  static const darkThemeBlackScaffold = Color(0xFF1D2024);
  static const darkThemeDisabledText = Color(0xFFE4E6ED);
  static const darkThemeDisabledBackground = Color(0xFF2D2F34);

  ///
  /// LIGHT2 THEME
  ///

  static const light2ThemeBlackText = Color(0xFF121C2B);
  static const light2ThemeWhiteBackground = Color(0xFFF9F9FF);
  static const light2ThemeButtonBackground = Color(0xFFE4E6ED);
  static const light2ThemeWhiteScaffold = Color(0xFFEDEDF4);
  static const light2ThemeDisabledText = Color(0xFF2D2F34);
  static const light2ThemeDisabledBackground = Color(0xFFE4E6ED);

  ///
  /// DARK2 THEME
  ///

  static const dark2ThemeWhiteText = Color(0xFFF9F9FF);
  static const dark2ThemeBlackBackground = Color(0xFF243145);
  static const dark2ThemeButtonBackground = Color(0xFF2D2F34);
  static const dark2ThemeBlackScaffold = Color(0xFF1B2432);
  static const dark2ThemeDisabledText = Color(0xFFE4E6ED);
  static const dark2ThemeDisabledBackground = Color(0xFF2D2F34);

  ///
  /// DELETE
  ///

  static const redDelete = Color(0xFFE0777D);

  ///
  /// PRIMARY COLORS
  ///

  static const green = Color(0xFF57CC99);
  static const red = Color(0xFFE0777D);
  static const blue = Color(0xFF90BEDE);
  static const darkBlue = Color(0xFF556CC9);
  static const purple = Color(0xFF947BD3);
  static const yellow = Color(0xFFF0C987);
  static const pink = Color(0xFFFAB2EA);
}

class TroskoColorsExtension extends ThemeExtension<TroskoColorsExtension> {
  final Color text;
  final Color buttonPrimary;
  final Color delete;
  final Color listTileBackground;
  final Color buttonBackground;
  final Color scaffoldBackground;
  final Color disabledText;
  final Color disabledBackground;

  TroskoColorsExtension({
    required this.text,
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
    Color? buttonPrimary,
    Color? delete,
    Color? listTileBackground,
    Color? buttonBackground,
    Color? filledButtonBackground,
    Color? scaffoldBackground,
    Color? disabledText,
    Color? disabledBackground,
  }) => TroskoColorsExtension(
    text: text ?? this.text,
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
