import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/durations.dart';
import '../../../models/month/month.dart';
import '../../../theme/theme.dart';
import '../../../util/string.dart';

class HomeMonthChips extends StatelessWidget {
  final List<Month> months;
  final Month activeMonth;
  final Function(Month newMonth) onChipPressed;

  const HomeMonthChips({
    required this.months,
    required this.activeMonth,
    required this.onChipPressed,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (_, index) {
          final month = months[index];

          return Animate(
            effects: [
              FadeEffect(
                duration: TroskoDurations.animationDuration,
                delay: (75 * index).ms,
                curve: Curves.easeIn,
              ),
            ],
            child: FilterChip(
              label: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 40,
                ),
                child: Text(
                  capitalize(month.label),
                  style: context.textStyles.homeMonthChip,
                  textAlign: TextAlign.center,
                ),
              ),
              selected: activeMonth == month,
              onSelected: (_) => onChipPressed(month),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
      ),
    ),
  );
}
