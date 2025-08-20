import 'package:flutter/material.dart';

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

    return defaultTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightAppColors.primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            lightAppColors.primary,
          ),
          foregroundColor: WidgetStateProperty.all(
            lightAppColors.background,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
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
    tertiary: TroskoColors.pink,
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
  button: TroskoTextStyles.button.copyWith(
    color: colorsExtension.text,
  ),
  homeTopTitle: TroskoTextStyles.homeTopTitle.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionTitle: TroskoTextStyles.homeTransactionTitle.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionSubtitle: TroskoTextStyles.homeTransactionSubtitle.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionValue: TroskoTextStyles.homeTransactionValue.copyWith(
    color: colorsExtension.text,
  ),
  transactionTopTitle: TroskoTextStyles.transactionTopTitle.copyWith(
    color: colorsExtension.text,
  ),
  transactionAmountTitle: TroskoTextStyles.transactionAmountTitle.copyWith(
    color: colorsExtension.text,
  ),
  transactionAmountCurrentValue: TroskoTextStyles.transactionAmountCurrentValue.copyWith(
    color: colorsExtension.text,
  ),
  transactionAmountNumber: TroskoTextStyles.transactionAmountNumber.copyWith(
    color: colorsExtension.text,
  ),
  transactionNameTextField: TroskoTextStyles.transactionNameTextField.copyWith(
    color: colorsExtension.text,
  ),
  transactionCategoryName: TroskoTextStyles.transactionCategoryName.copyWith(
    color: colorsExtension.text,
  ),
);
