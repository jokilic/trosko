import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/durations.dart';
import '../../../models/category/category.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import '../../../util/color.dart';
import '../../../util/currency.dart';
import '../../../util/icons.dart';
import '../../../util/stats.dart';

class StatsCategoryListTile extends StatefulWidget {
  final Category category;
  final int numberOfTransactions;
  final int amountCents;

  const StatsCategoryListTile({
    required this.category,
    required this.numberOfTransactions,
    required this.amountCents,
  });

  @override
  State<StatsCategoryListTile> createState() => _StatsCategoryListTileState();
}

class _StatsCategoryListTileState extends State<StatsCategoryListTile> {
  var expanded = false;

  void toggleExpanded() => setState(
    () => expanded = !expanded,
  );

  @override
  Widget build(BuildContext context) => AnimatedSize(
    alignment: Alignment.topCenter,
    duration: TroskoDurations.animation,
    curve: Curves.easeIn,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 1,
      ),
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
                      // color: widget.category.color,
                      border: Border.all(
                        // color: widget.category.color,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      getBoldIconFromName(
                        widget.category.iconName,
                      )?.value,
                      color: getWhiteOrBlackColor(
                        backgroundColor: Colors.green,
                        whiteColor: TroskoColors.lighterGrey,
                        blackColor: TroskoColors.black,
                      ),
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
                            widget.category.name,
                            style: context.textStyles.homeTransactionTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          secondChild: Text(
                            widget.category.name,
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
