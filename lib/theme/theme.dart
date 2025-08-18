import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';

class TroskoTheme {
  ///
  /// LIGHT
  ///

  static ThemeData get light {
    final defaultTheme = ThemeData.light();

    return defaultTheme.copyWith(
      extensions: [
        lightAppColors,
        lightTextTheme,
      ],
    );
  }

  static final lightAppColors = TroskoColorsExtension(
    primary: TroskoColors.green,
    background: TroskoColors.white,
    text: TroskoColors.black,
    secondary: TroskoColors.pink,
  );

  static final lightTextTheme = getTextThemesExtension(
    colorsExtension: lightAppColors,
  );
}

extension TroskoThemeExtension on ThemeData {
  TroskoColorsExtension get troskoColors => extension<TroskoColorsExtension>() ?? TroskoTheme.lightAppColors;
  TroskoTextThemesExtension get troskoTextStyles => extension<TroskoTextThemesExtension>() ?? TroskoTheme.lightTextTheme;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
  TroskoColorsExtension get colors => theme.troskoColors;
  TroskoTextThemesExtension get textStyles => theme.troskoTextStyles;
}

TroskoTextThemesExtension getTextThemesExtension({
  required TroskoColorsExtension colorsExtension,
}) => TroskoTextThemesExtension(
  appBarTitle: TroskoTextStyles.appBarTitle.copyWith(
    color: colorsExtension.text,
  ),
);
