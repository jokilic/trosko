import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'text_styles.dart';

class TroskoTheme {
  ///
  /// LIGHT
  ///

  static ThemeData get light {
    final defaultTheme = ThemeData.light(
      useMaterial3: true,
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: lightAppColors.primary,
    );

    return defaultTheme.copyWith(
      colorScheme: scheme,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(scheme.secondaryContainer),
          foregroundColor: WidgetStateProperty.all(scheme.onSecondaryContainer),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          textStyle: WidgetStateProperty.all(
            lightTextTheme.button,
          ),
        ),
      ),
      scaffoldBackgroundColor: lightAppColors.background,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: lightAppColors.primary,
        cursorColor: lightAppColors.primary,
        selectionHandleColor: lightAppColors.primary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      extensions: [
        lightAppColors,
        lightTextTheme,
      ],
    );
  }

  static final lightAppColors = TroskoColorsExtension(
    primary: TroskoColors.blue,
    background: TroskoColors.white,
    text: TroskoColors.black,
    secondary: TroskoColors.green,
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
  button: TroskoTextStyles.button.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionTitle: TroskoTextStyles.homeTransactionTitle.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionSubtitle: TroskoTextStyles.homeTransactionSubtitle.copyWith(
    color: colorsExtension.text,
  ),
);
