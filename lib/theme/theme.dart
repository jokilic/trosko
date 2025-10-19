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
        const TroskoThemeTag(
          TroskoThemeId.dark,
        ),
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

  ///
  /// BLUE
  ///

  static ThemeData blue({
    required Color? primaryColor,
  }) {
    final defaultTheme = ThemeData.dark(
      useMaterial3: true,
    );

    final blueAppColors = getBlueAppColors(
      primaryColor: primaryColor,
    );

    final blueTextTheme = getBlueTextTheme(
      primaryColor: primaryColor,
    );

    return defaultTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor ?? blueAppColors.buttonPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor ?? blueAppColors.buttonPrimary,
        foregroundColor: blueAppColors.text,
        elevation: 1,
        disabledElevation: 1,
        highlightElevation: 2,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            primaryColor ?? blueAppColors.buttonPrimary,
          ),
          foregroundColor: WidgetStateProperty.all(
            blueAppColors.buttonBackground,
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
            blueTextTheme.button,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
        backgroundColor: blueAppColors.buttonBackground,
        selectedColor: primaryColor ?? blueAppColors.buttonPrimary,
        showCheckmark: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 1,
        pressElevation: 2,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: blueAppColors.text,
          highlightColor: Colors.transparent,
          iconSize: 28,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          elevation: 1,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: blueAppColors.buttonBackground,
      scaffoldBackgroundColor: blueAppColors.scaffoldBackground,
      canvasColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: primaryColor ?? blueAppColors.buttonPrimary,
        cursorColor: primaryColor ?? blueAppColors.buttonPrimary,
        selectionHandleColor: primaryColor ?? blueAppColors.buttonPrimary,
      ),
      extensions: [
        blueAppColors,
        blueTextTheme,
        const TroskoThemeTag(
          TroskoThemeId.blue,
        ),
      ],
    );
  }

  static TroskoColorsExtension getBlueAppColors({
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

  static TroskoTextThemesExtension getBlueTextTheme({
    required Color? primaryColor,
  }) => getTextThemesExtension(
    colorsExtension: getBlueAppColors(
      primaryColor: primaryColor,
    ),
  );
}
