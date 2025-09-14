import 'package:flutter/material.dart';

import '../../../models/month/month.dart';
import '../../../theme/theme.dart';
import '../../../util/string.dart';

class HomeMonthChips extends StatelessWidget {
  final List<Month> months;
  final Month? activeMonth;
  final Function(Month? newMonth) onChipPressed;

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
        itemCount: months.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            ///
            /// ALL
            ///
            return Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: activeMonth == null ? context.colors.buttonBackground : context.colors.listTileBackground,
              ),
              child: FilterChip(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 40,
                  ),
                  child: Text(
                    'All',
                    style: context.textStyles.homeMonthChip,
                    textAlign: TextAlign.center,
                  ),
                ),
                selected: activeMonth == null,
                onSelected: (_) => onChipPressed(
                  Month(
                    date: DateTime.fromMillisecondsSinceEpoch(0),
                    label: 'All',
                  ),
                ),
              ),
            );
          }

          ///
          /// MONTH
          ///
          final month = months.elementAtOrNull(index - 1);

          if (month != null) {
            return Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: activeMonth == month ? context.colors.buttonBackground : context.colors.listTileBackground,
              ),
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
          }

          return const SizedBox.shrink();
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
      ),
    ),
  );
}
