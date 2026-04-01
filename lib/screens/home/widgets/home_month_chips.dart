import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../models/month/month.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';
import '../../../util/string.dart';

class HomeMonthChips extends StatelessWidget {
  final List<Month> months;
  final List<Month>? activeMonths;
  final Function(Month? newMonth) onChipPressed;
  final Function(Month? newMonth)? onLongPressed;

  const HomeMonthChips({
    required this.months,
    required this.activeMonths,
    required this.onChipPressed,
    this.onLongPressed,
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
                highlightColor: (activeMonths?.isEmpty ?? true) ? context.colors.buttonBackground : context.colors.listTileBackground,
              ),
              child: InkWell(
                onLongPress: () => onLongPressed != null ? onLongPressed!(Month.all()) : null,
                borderRadius: BorderRadius.circular(8),
                child: FilterChip(
                  label: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 40,
                    ),
                    child: Text(
                      'monthAll'.tr(),
                      style: context.textStyles.homeMonthChip.copyWith(
                        color: (activeMonths?.isEmpty ?? true)
                            ? getWhiteOrBlackColor(
                                backgroundColor: context.colors.buttonPrimary,
                                whiteColor: TroskoColors.lightThemeWhiteBackground,
                                blackColor: TroskoColors.lightThemeBlackText,
                              )
                            : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  selected: activeMonths?.isEmpty ?? true,
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
                highlightColor: activeMonths?.contains(month) ?? false ? context.colors.buttonBackground : context.colors.listTileBackground,
              ),
              child: InkWell(
                onLongPress: () => onLongPressed != null ? onLongPressed!(month) : null,
                borderRadius: BorderRadius.circular(8),
                child: FilterChip(
                  label: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 40,
                    ),
                    child: Text(
                      capitalize(month.label),
                      style: context.textStyles.homeMonthChip.copyWith(
                        color: activeMonths?.contains(month) ?? false
                            ? getWhiteOrBlackColor(
                                backgroundColor: context.colors.buttonPrimary,
                                whiteColor: TroskoColors.lightThemeWhiteBackground,
                                blackColor: TroskoColors.lightThemeBlackText,
                              )
                            : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  selected: activeMonths?.contains(month) ?? false,
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
