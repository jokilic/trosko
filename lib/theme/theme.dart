import 'package:flutter/material.dart';

import '../models/trosko_theme_tag/trosko_theme_tag.dart';
import 'colors.dart';
import 'extensions.dart';
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
        const TroskoThemeTag(
          TroskoThemeId.light,
        ),
      ],
    );
  }

  static TroskoColorsExtension getLightAppColors({
    required Color? primaryColor,
  }) => TroskoColorsExtension(
    text: TroskoColors.lightThemeBlackText,
    buttonPrimary: primaryColor ?? TroskoColors.green,
    delete: TroskoColors.redDelete,
    listTileBackground: TroskoColors.lightThemeWhiteBackground,
    buttonBackground: TroskoColors.lightThemeButtonBackground,
    scaffoldBackground: TroskoColors.lightThemeWhiteScaffold,
    disabledText: TroskoColors.lightThemeDisabledText,
    disabledBackground: TroskoColors.lightThemeDisabledBackground,
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
        const TroskoThemeTag(
          TroskoThemeId.dark,
        ),
      ],
    );
  }

  static TroskoColorsExtension getDarkAppColors({
    required Color? primaryColor,
  }) => TroskoColorsExtension(
    text: TroskoColors.darkThemeWhiteText,
    buttonPrimary: primaryColor ?? TroskoColors.green,
    delete: TroskoColors.redDelete,
    listTileBackground: TroskoColors.darkThemeBlackBackground,
    buttonBackground: TroskoColors.darkThemeButtonBackground,
    scaffoldBackground: TroskoColors.darkThemeBlackScaffold,
    disabledText: TroskoColors.darkThemeDisabledText,
    disabledBackground: TroskoColors.darkThemeDisabledBackground,
  );

  static TroskoTextThemesExtension getDarkTextTheme({
    required Color? primaryColor,
  }) => getTextThemesExtension(
    colorsExtension: getDarkAppColors(
      primaryColor: primaryColor,
    ),
  );

  ///
  /// LIGHT2
  ///

  static ThemeData light2({
    required Color? primaryColor,
  }) {
    final defaultTheme = ThemeData.light(
      useMaterial3: true,
    );

    final light2AppColors = getLight2AppColors(
      primaryColor: primaryColor,
    );

    final light2TextTheme = getLight2TextTheme(
      primaryColor: primaryColor,
    );

    return defaultTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor ?? light2AppColors.buttonPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor ?? light2AppColors.buttonPrimary,
        foregroundColor: light2AppColors.text,
        elevation: 1,
        disabledElevation: 1,
        highlightElevation: 2,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            primaryColor ?? light2AppColors.buttonPrimary,
          ),
          foregroundColor: WidgetStateProperty.all(
            light2AppColors.buttonBackground,
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
            light2TextTheme.button,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
        backgroundColor: light2AppColors.buttonBackground,
        selectedColor: primaryColor ?? light2AppColors.buttonPrimary,
        showCheckmark: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 1,
        pressElevation: 2,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: light2AppColors.text,
          highlightColor: Colors.transparent,
          iconSize: 28,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          elevation: 1,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: light2AppColors.buttonBackground,
      scaffoldBackgroundColor: light2AppColors.scaffoldBackground,
      canvasColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: primaryColor ?? light2AppColors.buttonPrimary,
        cursorColor: primaryColor ?? light2AppColors.buttonPrimary,
        selectionHandleColor: primaryColor ?? light2AppColors.buttonPrimary,
      ),
      extensions: [
        light2AppColors,
        light2TextTheme,
        const TroskoThemeTag(
          TroskoThemeId.light2,
        ),
      ],
    );
  }

  static TroskoColorsExtension getLight2AppColors({
    required Color? primaryColor,
  }) => TroskoColorsExtension(
    text: TroskoColors.light2ThemeBlackText,
    buttonPrimary: primaryColor ?? TroskoColors.green,
    delete: TroskoColors.redDelete,
    listTileBackground: TroskoColors.light2ThemeWhiteBackground,
    buttonBackground: TroskoColors.light2ThemeButtonBackground,
    scaffoldBackground: TroskoColors.light2ThemeWhiteScaffold,
    disabledText: TroskoColors.light2ThemeDisabledText,
    disabledBackground: TroskoColors.light2ThemeDisabledBackground,
  );

  static TroskoTextThemesExtension getLight2TextTheme({
    required Color? primaryColor,
  }) => getTextThemesExtension(
    colorsExtension: getLight2AppColors(
      primaryColor: primaryColor,
    ),
  );

  ///
  /// DARK2
  ///

  static ThemeData dark2({
    required Color? primaryColor,
  }) {
    final defaultTheme = ThemeData.dark(
      useMaterial3: true,
    );

    final dark2AppColors = getDark2AppColors(
      primaryColor: primaryColor,
    );

    final dark2TextTheme = getDark2TextTheme(
      primaryColor: primaryColor,
    );

    return defaultTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor ?? dark2AppColors.buttonPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor ?? dark2AppColors.buttonPrimary,
        foregroundColor: dark2AppColors.text,
        elevation: 1,
        disabledElevation: 1,
        highlightElevation: 2,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            primaryColor ?? dark2AppColors.buttonPrimary,
          ),
          foregroundColor: WidgetStateProperty.all(
            dark2AppColors.buttonBackground,
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
            dark2TextTheme.button,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
        backgroundColor: dark2AppColors.buttonBackground,
        selectedColor: primaryColor ?? dark2AppColors.buttonPrimary,
        showCheckmark: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 1,
        pressElevation: 2,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: dark2AppColors.text,
          highlightColor: Colors.transparent,
          iconSize: 28,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          elevation: 1,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: dark2AppColors.buttonBackground,
      scaffoldBackgroundColor: dark2AppColors.scaffoldBackground,
      canvasColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: primaryColor ?? dark2AppColors.buttonPrimary,
        cursorColor: primaryColor ?? dark2AppColors.buttonPrimary,
        selectionHandleColor: primaryColor ?? dark2AppColors.buttonPrimary,
      ),
      extensions: [
        dark2AppColors,
        dark2TextTheme,
        const TroskoThemeTag(
          TroskoThemeId.dark2,
        ),
      ],
    );
  }

  static TroskoColorsExtension getDark2AppColors({
    required Color? primaryColor,
  }) => TroskoColorsExtension(
    text: TroskoColors.dark2ThemeWhiteText,
    buttonPrimary: primaryColor ?? TroskoColors.green,
    delete: TroskoColors.redDelete,
    listTileBackground: TroskoColors.dark2ThemeBlackBackground,
    buttonBackground: TroskoColors.dark2ThemeButtonBackground,
    scaffoldBackground: TroskoColors.dark2ThemeBlackScaffold,
    disabledText: TroskoColors.dark2ThemeDisabledText,
    disabledBackground: TroskoColors.dark2ThemeDisabledBackground,
  );

  static TroskoTextThemesExtension getDark2TextTheme({
    required Color? primaryColor,
  }) => getTextThemesExtension(
    colorsExtension: getDark2AppColors(
      primaryColor: primaryColor,
    ),
  );
}
