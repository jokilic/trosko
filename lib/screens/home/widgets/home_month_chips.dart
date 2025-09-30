import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../models/month/month.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import '../../../util/color.dart';
import '../../../util/string.dart';

class HomeMonthChips extends StatelessWidget {
  final List<Month> months;
  final Month? activeMonth;
  final Function(Month? newMonth) onChipPressed;
  final Function(Month? newMonth)? onChipLongPressed;

  const HomeMonthChips({
    required this.months,
    required this.activeMonth,
    required this.onChipPressed,
    this.onChipLongPressed,
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
              child: InkWell(
                onLongPress: onChipLongPressed != null ? () => onChipLongPressed!(Month.all()) : null,
                borderRadius: BorderRadius.circular(8),
                child: FilterChip(
                  label: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 40,
                    ),
                    child: Text(
                      'monthAll'.tr(),
                      style: context.textStyles.homeMonthChip.copyWith(
                        color: activeMonth == null
                            ? getWhiteOrBlackColor(
                                backgroundColor: context.colors.buttonPrimary,
                                whiteColor: TroskoColors.lighterGrey,
                                blackColor: TroskoColors.black,
                              )
                            : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  selected: activeMonth == null,
                  onSelected: (_) => onChipPressed(Month.all()),
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
              child: InkWell(
                onLongPress: onChipLongPressed != null ? () => onChipLongPressed!(month) : null,
                borderRadius: BorderRadius.circular(8),
                child: FilterChip(
                  label: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 40,
                    ),
                    child: Text(
                      capitalize(month.label),
                      style: context.textStyles.homeMonthChip.copyWith(
                        color: activeMonth == month
                            ? getWhiteOrBlackColor(
                                backgroundColor: context.colors.buttonPrimary,
                                whiteColor: TroskoColors.lighterGrey,
                                blackColor: TroskoColors.black,
                              )
                            : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  selected: activeMonth == month,
                  onSelected: (_) => onChipPressed(month),
                ),
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
