import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/category/category.dart';
import '../../models/location/location.dart';
import '../../models/transaction/transaction.dart';
import '../../services/logger_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/color.dart';
import '../../util/stats.dart';
import 'widgets/stats_icon_widget.dart';

enum StatsSection {
  categories,
  locations,
}

class StatsController extends ValueNotifier<({StatsSection section, int touchedCategoryIndex, int touchedLocationIndex})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final List<Transaction> transactions;
  final List<Category> categories;
  final List<Location> locations;

  StatsController({
    required this.logger,
    required this.transactions,
    required this.categories,
    required this.locations,
  }) : super((section: StatsSection.categories, touchedCategoryIndex: -1, touchedLocationIndex: -1));

  ///
  /// CATEGORIES
  ///

  int getTotalCategoryAmount() =>
      calculateCategoryTotals(
        transactions: transactions,
      ).values.fold<int>(
        0,
        (sum, amount) => sum + amount,
      );

  List<MapEntry<String, int>> getCategoryEntries() {
    final entries = <MapEntry<String, int>>[];

    for (final entry in calculateCategoryTotals(
      transactions: transactions,
    ).entries) {
      final category = getCategoryById(
        id: entry.key,
        categories: categories,
      );

      if (category != null) {
        entries.add(entry);
      }
    }

    entries.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return entries;
  }

  Category? getTouchedCategory() {
    final categoryEntries = getCategoryEntries();
    final touchedCategoryIndex = value.touchedCategoryIndex;

    if (touchedCategoryIndex < 0 || touchedCategoryIndex >= categoryEntries.length) {
      return null;
    }

    return getCategoryById(
      id: categoryEntries[touchedCategoryIndex].key,
      categories: categories,
    );
  }

  int? getTouchedCategoryAmount() {
    final categoryEntries = getCategoryEntries();
    final touchedCategoryIndex = value.touchedCategoryIndex;

    if (touchedCategoryIndex < 0 || touchedCategoryIndex >= categoryEntries.length) {
      return null;
    }

    return categoryEntries[touchedCategoryIndex].value;
  }

  List<PieChartSectionData> getPieChartCategorySections({
    required bool useColorfulIcons,
    required BuildContext context,
  }) {
    final categoryEntries = getCategoryEntries();
    final sections = <PieChartSectionData>[];

    var index = 0;

    for (final entry in categoryEntries) {
      final category = getCategoryById(
        id: entry.key,
        categories: categories,
      );

      if (category == null) {
        continue;
      }

      final percentage = (entry.value / getTotalCategoryAmount()) * 100;
      final isTouched = index == value.touchedCategoryIndex;
      final radius = isTouched ? 104.0 : 96.0;

      sections.add(
        PieChartSectionData(
          borderSide: BorderSide(
            color: category.color,
            width: 1.5,
          ),
          showTitle: true,
          color: category.color,
          value: entry.value.toDouble(),
          title: percentage >= 5 ? '${percentage.toStringAsFixed(0)}%' : '',
          radius: radius,
          titleStyle: isTouched
              ? context.textStyles.homeTransactionTitle.copyWith(
                  color: getWhiteOrBlackColor(
                    backgroundColor: category.color,
                    whiteColor: TroskoColors.lightThemeWhiteBackground,
                    blackColor: TroskoColors.lightThemeBlackText,
                  ),
                )
              : context.textStyles.homeTransactionEuro.copyWith(
                  color: getWhiteOrBlackColor(
                    backgroundColor: category.color,
                    whiteColor: TroskoColors.lightThemeWhiteBackground,
                    blackColor: TroskoColors.lightThemeBlackText,
                  ),
                ),
          badgeWidget: percentage >= 3
              ? StatsIconWidget(
                  iconName: category.iconName,
                  color: category.color,
                  useColorfulIcons: useColorfulIcons,
                )
              : null,
          badgePositionPercentageOffset: 1.275,
        ),
      );

      index++;
    }

    return sections;
  }

  ///
  /// LOCATIONS
  ///

  int getTotalLocationAmount() =>
      calculateLocationTotals(
        transactions: transactions,
      ).values.fold<int>(
        0,
        (sum, amount) => sum + amount,
      );

  List<MapEntry<String, int>> getLocationEntries() {
    final entries = <MapEntry<String, int>>[];

    for (final entry in calculateLocationTotals(
      transactions: transactions,
    ).entries) {
      final location = getLocationById(
        id: entry.key,
        locations: locations,
      );

      if (location != null) {
        entries.add(entry);
      }
    }

    entries.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return entries;
  }

  Location? getTouchedLocation() {
    final locationEntries = getLocationEntries();
    final touchedLocationIndex = value.touchedLocationIndex;

    if (touchedLocationIndex < 0 || touchedLocationIndex >= locationEntries.length) {
      return null;
    }

    return getLocationById(
      id: locationEntries[touchedLocationIndex].key,
      locations: locations,
    );
  }

  int? getTouchedLocationAmount() {
    final locationEntries = getLocationEntries();
    final touchedLocationIndex = value.touchedLocationIndex;

    if (touchedLocationIndex < 0 || touchedLocationIndex >= locationEntries.length) {
      return null;
    }

    return locationEntries[touchedLocationIndex].value;
  }

  List<PieChartSectionData> getPieChartLocationSections({
    required bool useColorfulIcons,
    required BuildContext context,
  }) {
    final locationEntries = getLocationEntries();
    final sections = <PieChartSectionData>[];

    var index = 0;

    for (final entry in locationEntries) {
      final location = getLocationById(
        id: entry.key,
        locations: locations,
      );

      if (location == null) {
        continue;
      }

      final percentage = (entry.value / getTotalLocationAmount()) * 100;
      final isTouched = index == value.touchedLocationIndex;
      final radius = isTouched ? 104.0 : 96.0;

      sections.add(
        PieChartSectionData(
          borderSide: BorderSide(
            color: context.colors.buttonPrimary,
            width: 1.5,
          ),
          showTitle: true,
          color: context.colors.buttonPrimary,
          value: entry.value.toDouble(),
          title: percentage >= 5 ? '${percentage.toStringAsFixed(0)}%' : '',
          radius: radius,
          titleStyle: isTouched
              ? context.textStyles.homeTransactionTitle.copyWith(
                  color: getWhiteOrBlackColor(
                    backgroundColor: context.colors.buttonPrimary,
                    whiteColor: TroskoColors.lightThemeWhiteBackground,
                    blackColor: TroskoColors.lightThemeBlackText,
                  ),
                )
              : context.textStyles.homeTransactionEuro.copyWith(
                  color: getWhiteOrBlackColor(
                    backgroundColor: context.colors.buttonPrimary,
                    whiteColor: TroskoColors.lightThemeWhiteBackground,
                    blackColor: TroskoColors.lightThemeBlackText,
                  ),
                ),
          badgeWidget: percentage >= 3
              ? StatsIconWidget(
                  iconName: location.iconName,
                  color: context.colors.buttonBackground,
                  useColorfulIcons: useColorfulIcons,
                )
              : null,
          badgePositionPercentageOffset: 1.275,
        ),
      );

      index++;
    }

    return sections;
  }

  ///
  /// METHODS
  ///

  void toggleStatsSection() => updateState(
    section: value.section == StatsSection.categories ? StatsSection.locations : StatsSection.categories,
  );

  /// Updates `state`
  void updateState({
    StatsSection? section,
    int? touchedCategoryIndex,
    int? touchedLocationIndex,
  }) => value = (
    section: section ?? value.section,
    touchedCategoryIndex: touchedCategoryIndex ?? value.touchedCategoryIndex,
    touchedLocationIndex: touchedLocationIndex ?? value.touchedLocationIndex,
  );
}
