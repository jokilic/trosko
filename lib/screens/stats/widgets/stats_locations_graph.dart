import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../models/location/location.dart';
import '../../../util/dependencies.dart';
import '../stats_controller.dart';
import 'stats_center_text_widget.dart';

class StatsLocationsGraph extends WatchingWidget {
  final List<Location> locations;
  final bool useColorfulIcons;
  final String instanceName;

  const StatsLocationsGraph({
    required this.locations,
    required this.useColorfulIcons,
    required this.instanceName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<StatsController>(
      instanceName: instanceName,
    );

    final locationTotals = controller.getLocationEntries();
    final totalAmount = controller.getTotalLocationAmount();

    /// No data to display, show nothing
    if (locationTotals.isEmpty || totalAmount == 0) {
      return const SizedBox.shrink();
    }

    final touchedLocation = controller.getTouchedLocation();
    final touchedAmount = controller.getTouchedLocationAmount();

    final sections = controller.getPieChartLocationSections(
      useColorfulIcons: useColorfulIcons,
      context: context,
    );

    return SizedBox(
      height: 360,
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
                      touchedLocationIndex: -1,
                    );
                    return;
                  }

                  controller.updateState(
                    touchedLocationIndex: pieTouchResponse.touchedSection!.touchedSectionIndex,
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
          if (touchedLocation != null && touchedAmount != null)
            StatsCenterTextWidget(
              name: touchedLocation.name,
              amount: touchedAmount,
            ),
        ],
      ),
    );
  }
}
