import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';

class TroskoTheme {
  ///
  /// LIGHT
  ///

  static ThemeData light({
    required Color? primaryColor,
  }) {
    final defaultTheme = ThemeData.light(
      useMaterial3: true,
    );

    final lightAppColors = getLightAppColors(
      primaryColor: primaryColor,
    );

    final lightTextTheme = getLightTextTheme(
      primaryColor: primaryColor,
    );

    return defaultTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor ?? lightAppColors.buttonPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor ?? lightAppColors.buttonPrimary,
        foregroundColor: lightAppColors.text,
        elevation: 1,
        disabledElevation: 1,
        highlightElevation: 2,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            primaryColor ?? lightAppColors.buttonPrimary,
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
        selectedColor: primaryColor ?? lightAppColors.buttonPrimary,
        showCheckmark: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 1,
        pressElevation: 2,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: lightAppColors.text,
          highlightColor: Colors.transparent,
          iconSize: 28,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          elevation: 1,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: lightAppColors.buttonBackground,
      scaffoldBackgroundColor: lightAppColors.scaffoldBackground,
      canvasColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: primaryColor ?? lightAppColors.buttonPrimary,
        cursorColor: primaryColor ?? lightAppColors.buttonPrimary,
        selectionHandleColor: primaryColor ?? lightAppColors.buttonPrimary,
      ),
      extensions: [
        lightAppColors,
        lightTextTheme,
      ],
    );
  }

  static TroskoColorsExtension getLightAppColors({
    required Color? primaryColor,
  }) => TroskoColorsExtension(
    text: TroskoColors.black,
    icon: TroskoColors.black,
    buttonPrimary: primaryColor ?? TroskoColors.green,
    delete: TroskoColors.red,
    listTileBackground: TroskoColors.lighterGrey,
    buttonBackground: TroskoColors.grey,
    scaffoldBackground: TroskoColors.lightGrey,
    disabledText: TroskoColors.lighterDark,
    disabledBackground: TroskoColors.grey,
    borderColor: TroskoColors.black,
  );

  static TroskoTextThemesExtension getLightTextTheme({
    required Color? primaryColor,
  }) => getTextThemesExtension(
    colorsExtension: getLightAppColors(
      primaryColor: primaryColor,
    ),
  );

  ///
  /// DARK
  ///

  static ThemeData dark({
    required Color? primaryColor,
  }) {
    final defaultTheme = ThemeData.dark(
      useMaterial3: true,
    );

    final darkAppColors = getDarkAppColors(
      primaryColor: primaryColor,
    );

    final darkTextTheme = getDarkTextTheme(
      primaryColor: primaryColor,
    );

    return defaultTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor ?? darkAppColors.buttonPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor ?? darkAppColors.buttonPrimary,
        foregroundColor: darkAppColors.text,
        elevation: 1,
        disabledElevation: 1,
        highlightElevation: 2,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            primaryColor ?? darkAppColors.buttonPrimary,
          ),
          foregroundColor: WidgetStateProperty.all(
            darkAppColors.buttonBackground,
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
            darkTextTheme.button,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
        backgroundColor: darkAppColors.buttonBackground,
        selectedColor: primaryColor ?? darkAppColors.buttonPrimary,
        showCheckmark: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 1,
        pressElevation: 2,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: darkAppColors.text,
          highlightColor: Colors.transparent,
          iconSize: 28,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          elevation: 1,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: darkAppColors.buttonBackground,
      scaffoldBackgroundColor: darkAppColors.scaffoldBackground,
      canvasColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: primaryColor ?? darkAppColors.buttonPrimary,
        cursorColor: primaryColor ?? darkAppColors.buttonPrimary,
        selectionHandleColor: primaryColor ?? darkAppColors.buttonPrimary,
      ),
      extensions: [
        darkAppColors,
        darkTextTheme,
      ],
    );
  }

  static TroskoColorsExtension getDarkAppColors({
    required Color? primaryColor,
  }) => TroskoColorsExtension(
    text: TroskoColors.lighterGrey,
    icon: TroskoColors.lighterGrey,
    buttonPrimary: primaryColor ?? TroskoColors.green,
    delete: TroskoColors.red,
    listTileBackground: TroskoColors.lightDark,
    buttonBackground: TroskoColors.lighterDark,
    scaffoldBackground: TroskoColors.dark,
    disabledText: TroskoColors.grey,
    disabledBackground: TroskoColors.lighterDark,
    borderColor: TroskoColors.lightGrey,
  );

  static TroskoTextThemesExtension getDarkTextTheme({
    required Color? primaryColor,
  }) => getTextThemesExtension(
    colorsExtension: getDarkAppColors(
      primaryColor: primaryColor,
    ),
  );
}

extension TroskoThemeExtension on ThemeData {
  TroskoColorsExtension get troskoColors =>
      extension<TroskoColorsExtension>() ??
      TroskoTheme.getLightAppColors(
        primaryColor: TroskoColors.green,
      );
  TroskoTextThemesExtension get troskoTextStyles =>
      extension<TroskoTextThemesExtension>() ??
      TroskoTheme.getLightTextTheme(
        primaryColor: TroskoColors.green,
      );
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
  homeFloatingActionButton: TroskoTextStyles.homeFloatingActionButton.copyWith(
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
  homeTransactionTime: TroskoTextStyles.homeTransactionTime.copyWith(
    color: colorsExtension.text,
  ),
  homeTransactionNote: TroskoTextStyles.homeTransactionNote.copyWith(
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
  homeTitleBold: TroskoTextStyles.homeTitleBold.copyWith(
    color: colorsExtension.text,
  ),
  homeTitleEuro: TroskoTextStyles.homeTitleEuro.copyWith(
    color: colorsExtension.text,
  ),
  transactionAmountCurrentValue: TroskoTextStyles.transactionAmountCurrentValue.copyWith(
    color: colorsExtension.text,
  ),
  transactionAmountNumber: TroskoTextStyles.transactionAmountNumber.copyWith(
    color: colorsExtension.text,
  ),
  textField: TroskoTextStyles.textField.copyWith(
    color: colorsExtension.text,
  ),
  transactionCategoryName: TroskoTextStyles.transactionCategoryName.copyWith(
    color: colorsExtension.text,
  ),
  transactionTimeActive: TroskoTextStyles.transactionTimeActive.copyWith(
    color: colorsExtension.text,
  ),
  transactionTimeInactive: TroskoTextStyles.transactionTimeInactive.copyWith(
    color: colorsExtension.text,
  ),
  transactionDateInactive: TroskoTextStyles.transactionDateInactive.copyWith(
    color: colorsExtension.text,
  ),
  transactionDateActive: TroskoTextStyles.transactionDateActive.copyWith(
    color: colorsExtension.listTileBackground,
  ),
  categoryName: TroskoTextStyles.categoryName.copyWith(
    color: colorsExtension.text,
  ),
  categoryIcon: TroskoTextStyles.categoryIcon.copyWith(
    color: colorsExtension.text,
  ),
);
