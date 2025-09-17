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
        seedColor: lightAppColors.buttonPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightAppColors.buttonPrimary,
        foregroundColor: lightAppColors.text,
        elevation: 1,
        disabledElevation: 1,
        highlightElevation: 2,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            lightAppColors.buttonPrimary,
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
        selectedColor: lightAppColors.buttonPrimary,
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
        selectionColor: lightAppColors.buttonPrimary,
        cursorColor: lightAppColors.buttonPrimary,
        selectionHandleColor: lightAppColors.buttonPrimary,
      ),
      extensions: [
        lightAppColors,
        lightTextTheme,
      ],
    );
  }

  static final lightAppColors = TroskoColorsExtension(
    text: TroskoColors.black,
    icon: TroskoColors.grey,
    buttonPrimary: TroskoColors.blueLight,
    delete: TroskoColors.red,
    listTileBackground: TroskoColors.lighterGrey,
    buttonBackground: TroskoColors.grey,
    scaffoldBackground: TroskoColors.lightGrey,
    disabledText: TroskoColors.lighterDark,
    disabledBackground: TroskoColors.grey,
  );

  static final lightTextTheme = getTextThemesExtension(
    colorsExtension: lightAppColors,
  );

  ///
  /// DARK
  ///

  static ThemeData get dark {
    final defaultTheme = ThemeData.dark(
      useMaterial3: true,
    );

    return defaultTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkAppColors.buttonPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkAppColors.buttonPrimary,
        foregroundColor: darkAppColors.text,
        elevation: 1,
        disabledElevation: 1,
        highlightElevation: 2,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            darkAppColors.buttonPrimary,
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
        selectedColor: darkAppColors.buttonPrimary,
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
        selectionColor: darkAppColors.buttonPrimary,
        cursorColor: darkAppColors.buttonPrimary,
        selectionHandleColor: darkAppColors.buttonPrimary,
      ),
      extensions: [
        darkAppColors,
        darkTextTheme,
      ],
    );
  }

  static final darkAppColors = TroskoColorsExtension(
    text: TroskoColors.lighterGrey,
    icon: TroskoColors.grey,
    buttonPrimary: TroskoColors.blueDark,
    delete: TroskoColors.red,
    listTileBackground: TroskoColors.lightDark,
    buttonBackground: TroskoColors.lighterDark,
    scaffoldBackground: TroskoColors.dark,
    disabledText: TroskoColors.grey,
    disabledBackground: TroskoColors.lighterDark,
  );

  static final darkTextTheme = getTextThemesExtension(
    colorsExtension: darkAppColors,
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
  transactionDateTimeActive: TroskoTextStyles.transactionDateTimeActive.copyWith(
    color: colorsExtension.text,
  ),
  transactionDateTimeInactive: TroskoTextStyles.transactionDateTimeInactive.copyWith(
    color: colorsExtension.text,
  ),
  categoryName: TroskoTextStyles.categoryName.copyWith(
    color: colorsExtension.text,
  ),
  categoryIcon: TroskoTextStyles.categoryIcon.copyWith(
    color: colorsExtension.text,
  ),
);
