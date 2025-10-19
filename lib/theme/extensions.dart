import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';
import 'theme.dart';

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
