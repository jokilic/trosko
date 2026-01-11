import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/category/category.dart';
import '../../models/transaction/transaction.dart';
import '../../services/logger_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/color.dart';
import '../../util/stats.dart';
import 'widgets/stats_category_icon.dart';

enum StatsSection {
  categories,
  locations,
}

class StatsController extends ValueNotifier<({StatsSection section, int touchedCategoryIndex})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final List<Transaction> transactions;
  final List<Category> categories;

  StatsController({
    required this.logger,
    required this.transactions,
    required this.categories,
  }) : super((section: StatsSection.categories, touchedCategoryIndex: -1));

  ///
  /// METHODS
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

  List<PieChartSectionData> getPieChartSections({
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
      final radius = isTouched ? 88.0 : 80.0;

      sections.add(
        PieChartSectionData(
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
              ? StatsCategoryIcon(
                  category: category,
                  useColorfulIcons: useColorfulIcons,
                )
              : null,
          badgePositionPercentageOffset: 1.325,
        ),
      );

      index++;
    }

    return sections;
  }

  void toggleStatsSection() => updateState(
    section: value.section == StatsSection.categories ? StatsSection.locations : StatsSection.categories,
  );

  /// Updates `state`
  void updateState({
    StatsSection? section,
    int? touchedCategoryIndex,
  }) => value = (
    section: section ?? value.section,
    touchedCategoryIndex: touchedCategoryIndex ?? value.touchedCategoryIndex,
  );
}
