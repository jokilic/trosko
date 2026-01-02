import 'dart:async';

import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/durations.dart';
import '../models/category/category.dart';
import '../models/location/location.dart';
import '../models/transaction/transaction.dart';
import '../theme/colors.dart';
import '../theme/extensions.dart';
import '../util/color.dart';
import '../util/currency.dart';
import '../util/icons.dart';

class TroskoTransactionListTile extends StatefulWidget {
  final Function() onLongPressed;
  final Function() onDeletePressed;
  final Transaction transaction;
  final Category? category;
  final Location? location;

  const TroskoTransactionListTile({
    required this.onLongPressed,
    required this.onDeletePressed,
    required this.transaction,
    required this.category,
    required this.location,
  });

  @override
  State<TroskoTransactionListTile> createState() => _TroskoTransactionListTileState();
}

class _TroskoTransactionListTileState extends State<TroskoTransactionListTile> {
  var expanded = false;

  void toggleExpanded() => setState(
    () => expanded = !expanded,
  );

  @override
  Widget build(BuildContext context) {
    final boldCategoryIcon = getPhosphorIconFromName(
      widget.category?.iconName,
    )?.value;

    final boldLocationIcon = getPhosphorIconFromName(
      widget.location?.iconName,
    )?.value;

    return OpenContainer(
      transitionDuration: TroskoDurations.animationLong,
      transitionType: ContainerTransitionType.fadeThrough,
      middleColor: context.colors.scaffoldBackground,
      openElevation: 0,
      openColor: context.colors.scaffoldBackground,
      openShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      closedElevation: 0,
      closedColor: context.colors.scaffoldBackground,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      closedBuilder: (context, openContainer) => AnimatedSize(
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
            child: SwipeActionCell(
              key: ValueKey(widget.transaction),
              backgroundColor: context.colors.scaffoldBackground,
              openAnimationDuration: 175,
              closeAnimationDuration: 175,
              deleteAnimationDuration: 175,
              openAnimationCurve: Curves.easeIn,
              closeAnimationCurve: Curves.easeIn,
              leadingActions: [
                SwipeAction(
                  onTap: (handler) async {
                    unawaited(
                      handler(true),
                    );
                    await widget.onDeletePressed();
                  },
                  color: context.colors.delete,
                  backgroundRadius: 16,
                  icon: PhosphorIcon(
                    PhosphorIcons.trash(
                      PhosphorIconsStyle.bold,
                    ),
                    color: context.colors.listTileBackground,
                    size: 28,
                  ),
                ),
              ],
              child: Material(
                color: context.colors.listTileBackground,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: toggleExpanded,
                  onLongPress: openContainer,
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
                            color: widget.category?.color,
                            border: Border.all(
                              color: widget.category?.color ?? context.colors.text,
                              width: 1.5,
                            ),
                          ),
                          child: boldCategoryIcon != null
                              ? PhosphorIcon(
                                  getPhosphorIcon(
                                    boldCategoryIcon,
                                    isDuotone: false,
                                    isBold: true,
                                  ),
                                  color: getWhiteOrBlackColor(
                                    backgroundColor: widget.category?.color ?? context.colors.scaffoldBackground,
                                    whiteColor: TroskoColors.lightThemeWhiteBackground,
                                    blackColor: TroskoColors.lightThemeBlackText,
                                  ),
                                  duotoneSecondaryColor: context.colors.buttonPrimary,
                                  size: 16,
                                )
                              : null,
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
                                  widget.transaction.name,
                                  style: context.textStyles.homeTransactionTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                secondChild: Text(
                                  widget.transaction.name,
                                  style: context.textStyles.homeTransactionTitle,
                                ),
                              ),

                              ///
                              /// TIME
                              ///
                              const SizedBox(height: 4),
                              AnimatedCrossFade(
                                duration: TroskoDurations.animation,
                                firstCurve: Curves.easeIn,
                                secondCurve: Curves.easeIn,
                                sizeCurve: Curves.easeIn,
                                crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                firstChild: Text(
                                  DateFormat(
                                    'HH:mm',
                                    context.locale.languageCode,
                                  ).format(
                                    widget.transaction.createdAt,
                                  ),
                                  style: context.textStyles.homeTransactionTime,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                secondChild: Text(
                                  DateFormat(
                                    'HH:mm',
                                    context.locale.languageCode,
                                  ).format(
                                    widget.transaction.createdAt,
                                  ),
                                  style: context.textStyles.homeTransactionTime,
                                ),
                              ),

                              ///
                              /// NOTE
                              ///
                              if (widget.transaction.note?.isNotEmpty ?? false) ...[
                                const SizedBox(height: 2),
                                AnimatedCrossFade(
                                  duration: TroskoDurations.animation,
                                  firstCurve: Curves.easeIn,
                                  secondCurve: Curves.easeIn,
                                  sizeCurve: Curves.easeIn,
                                  crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  firstChild: Text(
                                    widget.transaction.note!,
                                    style: context.textStyles.homeTransactionNote,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  secondChild: Text(
                                    widget.transaction.note!,
                                    style: context.textStyles.homeTransactionNote,
                                  ),
                                ),
                              ],

                              ///
                              /// LOCATION
                              ///
                              if (widget.location != null) ...[
                                const SizedBox(height: 3),
                                AnimatedCrossFade(
                                  duration: TroskoDurations.animation,
                                  firstCurve: Curves.easeIn,
                                  secondCurve: Curves.easeIn,
                                  sizeCurve: Curves.easeIn,
                                  crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  firstChild: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      PhosphorIcon(
                                        getPhosphorIcon(
                                          boldLocationIcon ?? PhosphorIcons.mapTrifold,
                                          isDuotone: false,
                                          isBold: true,
                                        ),
                                        color: context.colors.text,
                                        duotoneSecondaryColor: context.colors.buttonPrimary,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          widget.location!.name,
                                          style: context.textStyles.homeTransactionTime,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  secondChild: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      PhosphorIcon(
                                        getPhosphorIcon(
                                          boldLocationIcon ?? PhosphorIcons.mapTrifold,
                                          isDuotone: false,
                                          isBold: true,
                                        ),
                                        color: context.colors.text,
                                        duotoneSecondaryColor: context.colors.buttonPrimary,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          widget.location!.name,
                                          style: context.textStyles.homeTransactionTime,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                                  widget.transaction.amountCents,
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
        ),
      ),
      openBuilder: (context, _) => widget.onLongPressed(),
    );
  }
}
