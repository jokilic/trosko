import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../models/category/category.dart';
import '../../../util/dependencies.dart';
import '../stats_controller.dart';
import 'stats_category_center_text.dart';

class StatsCategoryGraph extends WatchingWidget {
  final List<Category> categories;
  final bool useColorfulIcons;
  final String instanceName;

  const StatsCategoryGraph({
    required this.categories,
    required this.useColorfulIcons,
    required this.instanceName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<StatsController>(
      instanceName: instanceName,
    );

    final categoryTotals = controller.getCategoryEntries();
    final totalAmount = controller.getTotalCategoryAmount();

    /// No data to display, show nothing
    if (categoryTotals.isEmpty || totalAmount == 0) {
      return const SizedBox.shrink();
    }

    final touchedCategory = controller.getTouchedCategory();
    final touchedAmount = controller.getTouchedCategoryAmount();

    final sections = controller.getPieChartSections(
      useColorfulIcons: useColorfulIcons,
      context: context,
    );

    return SizedBox(
      height: 304,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ///
          /// CHART
          ///
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, pieTouchResponse) {
                  if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                    controller.updateState(
                      touchedCategoryIndex: -1,
                    );
                    return;
                  }

                  controller.updateState(
                    touchedCategoryIndex: pieTouchResponse.touchedSection!.touchedSectionIndex,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 56,
              sections: sections,
            ),
          ),

          ///
          /// CENTER TEXT
          ///
          if (touchedCategory != null && touchedAmount != null)
            StatsCategoryCenterText(
              category: touchedCategory,
              amount: touchedAmount,
            ),
        ],
      ),
    );
  }
}
