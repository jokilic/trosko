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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightAppColors.primary,
        foregroundColor: lightAppColors.text,
        elevation: 2,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            lightAppColors.primary,
          ),
          foregroundColor: WidgetStateProperty.all(
            lightAppColors.buttonBackground,
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
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
        backgroundColor: lightAppColors.buttonBackground,
        selectedColor: lightAppColors.primary,
        showCheckmark: false,
        elevation: 0,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: lightAppColors.buttonBackground,
          foregroundColor: lightAppColors.text,
          highlightColor: lightAppColors.buttonBackground,
          iconSize: 28,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          elevation: 2,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: lightAppColors.buttonBackground,
      scaffoldBackgroundColor: lightAppColors.scaffoldBackground,
      canvasColor: Colors.transparent,
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
    primary: TroskoColors.lightBlue,
    background: TroskoColors.white,
    buttonBackground: TroskoColors.grey,
    text: TroskoColors.black,
    scaffoldBackground: TroskoColors.lightGrey,
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
  appBarTitleSmall: TroskoTextStyles.appBarTitleSmall.copyWith(
    color: colorsExtension.text,
  ),
  appBarTitleBig: TroskoTextStyles.appBarTitleBig.copyWith(
    color: colorsExtension.text,
  ),
  appBarSubtitleBig: TroskoTextStyles.appBarSubtitleBig.copyWith(
    color: colorsExtension.text,
  ),
  homeTopTitle: TroskoTextStyles.homeTopTitle.copyWith(
    color: colorsExtension.text,
  ),
  homeMonthChip: TroskoTextStyles.homeMonthChip.copyWith(
    color: colorsExtension.text,
  ),
  homeCategoryTitle: TroskoTextStyles.homeCategoryTitle.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionTitle: TroskoTextStyles.homeTransactionTitle.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionSubtitle: TroskoTextStyles.homeTransactionSubtitle.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionTimeAgo: TroskoTextStyles.homeTransactionTimeAgo.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionValue: TroskoTextStyles.homeTransactionValue.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionEuro: TroskoTextStyles.homeTransactionEuro.copyWith(
    color: colorsExtension.text,
  ),
  homeTitle: TroskoTextStyles.homeTitle.copyWith(
    color: colorsExtension.text,
  ),
  transactionAmountCurrentValue: TroskoTextStyles.transactionAmountCurrentValue.copyWith(
    color: colorsExtension.text,
  ),
  transactionAmountNumber: TroskoTextStyles.transactionAmountNumber.copyWith(
    color: colorsExtension.text,
  ),
  transactionDateText: TroskoTextStyles.transactionDateText.copyWith(
    color: colorsExtension.text,
  ),
  transactionNameTextField: TroskoTextStyles.transactionNameTextField.copyWith(
    color: colorsExtension.text,
  ),
  transactionCategoryName: TroskoTextStyles.transactionCategoryName.copyWith(
    color: colorsExtension.text,
  ),
);
