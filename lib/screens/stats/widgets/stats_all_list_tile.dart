import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/durations.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';
import '../../../util/currency.dart';
import '../../../util/icons.dart';
import '../../../util/stats.dart';

class StatsAllListTile extends StatefulWidget {
  final int numberOfTransactions;
  final int amountCents;
  final bool useColorfulIcons;

  const StatsAllListTile({
    required this.numberOfTransactions,
    required this.amountCents,
    required this.useColorfulIcons,
  });

  @override
  State<StatsAllListTile> createState() => _StatsAllListTileState();
}

class _StatsAllListTileState extends State<StatsAllListTile> {
  var expanded = false;

  void toggleExpanded() => setState(
    () => expanded = !expanded,
  );

  @override
  Widget build(BuildContext context) => AnimatedSize(
    alignment: Alignment.topCenter,
    duration: TroskoDurations.animation,
    curve: Curves.easeIn,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.listTileBackground,
        border: Border.all(
          color: context.colors.text,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: context.colors.listTileBackground,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: toggleExpanded,
            highlightColor: context.colors.buttonBackground,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///
                  /// LEADING
                  ///
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                    ),
                    child: PhosphorIcon(
                      getPhosphorIcon(
                        PhosphorIcons.coins,
                        isDuotone: widget.useColorfulIcons,
                        isBold: true,
                      ),
                      color: getWhiteOrBlackColor(
                        backgroundColor: context.colors.scaffoldBackground,
                        whiteColor: TroskoColors.lightThemeWhiteBackground,
                        blackColor: TroskoColors.lightThemeBlackText,
                      ),
                      duotoneSecondaryColor: context.colors.buttonPrimary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),

                  ///
                  /// TITLE & SUBTITLE
                  ///
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),

                        ///
                        /// TITLE
                        ///
                        AnimatedCrossFade(
                          duration: TroskoDurations.animation,
                          firstCurve: Curves.easeIn,
                          secondCurve: Curves.easeIn,
                          sizeCurve: Curves.easeIn,
                          crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          firstChild: Text(
                            'monthAll'.tr(),
                            style: context.textStyles.homeTransactionTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          secondChild: Text(
                            'monthAll'.tr(),
                            style: context.textStyles.homeTransactionTitle,
                          ),
                        ),

                        ///
                        /// NUMBER OF TRANSACTIONS
                        ///
                        const SizedBox(height: 4),
                        AnimatedCrossFade(
                          duration: TroskoDurations.animation,
                          firstCurve: Curves.easeIn,
                          secondCurve: Curves.easeIn,
                          sizeCurve: Curves.easeIn,
                          crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          firstChild: Text(
                            getStatsSubtitle(
                              numberOfTransactions: widget.numberOfTransactions,
                              languageCode: context.locale.languageCode,
                            ),
                            style: context.textStyles.homeTransactionTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          secondChild: Text(
                            getStatsSubtitle(
                              numberOfTransactions: widget.numberOfTransactions,
                              languageCode: context.locale.languageCode,
                            ),
                            style: context.textStyles.homeTransactionTime,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///
                  /// TRAILING
                  ///
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          text: formatCentsToCurrency(
                            widget.amountCents,
                            locale: context.locale.languageCode,
                          ),
                          children: [
                            TextSpan(
                              text: 'homeCurrency'.tr(),
                              style: context.textStyles.homeTransactionEuro,
                            ),
                          ],
                        ),
                        style: context.textStyles.homeTransactionValue,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
