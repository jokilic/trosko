import 'dart:async';

import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/durations.dart';
import '../../../models/category/category.dart';
import '../../../models/location/location.dart';
import '../../../models/transaction/ai_transaction.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';
import '../../../util/currency.dart';
import '../../../util/icons.dart';

class VoiceAITransactionListTile extends StatefulWidget {
  final Function() onLongPressed;
  final Function() onDeletePressed;
  final AITransaction aiTransaction;
  final Category? category;
  final Location? location;
  final bool useColorfulIcons;

  const VoiceAITransactionListTile({
    required this.onLongPressed,
    required this.onDeletePressed,
    required this.aiTransaction,
    required this.category,
    required this.location,
    required this.useColorfulIcons,
  });

  @override
  State<VoiceAITransactionListTile> createState() => _VoiceIiTransactionListTileState();
}

class _VoiceIiTransactionListTileState extends State<VoiceAITransactionListTile> {
  var expanded = false;

  void toggleExpanded() => setState(
    () => expanded = !expanded,
  );

  @override
  Widget build(BuildContext context) {
    final hasName = widget.aiTransaction.name?.isNotEmpty ?? false;
    final hasAmount = widget.aiTransaction.amountCents != null;
    final hasCreatedAt = widget.aiTransaction.createdAt != null;
    final hasCategory = widget.category != null;

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
              key: ValueKey(widget.aiTransaction),
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
                    getPhosphorIcon(
                      PhosphorIcons.trash,
                      isDuotone: widget.useColorfulIcons,
                      isBold: true,
                    ),
                    color: context.colors.listTileBackground,
                    duotoneSecondaryColor: context.colors.buttonPrimary,
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
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.category?.color,
                            border: Border.all(
                              color: widget.category?.color ?? context.colors.delete,
                              width: 1.5,
                            ),
                          ),
                          child: hasCategory
                              ? boldCategoryIcon != null
                                    ? PhosphorIcon(
                                        getPhosphorIcon(
                                          boldCategoryIcon,
                                          isDuotone: widget.useColorfulIcons,
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
                                    : null
                              : Text(
                                  '?',
                                  style: context.textStyles.homeTransactionValue.copyWith(
                                    color: context.colors.delete,
                                  ),
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
                                  widget.aiTransaction.name ?? 'voiceAddTitle'.tr(),
                                  style: context.textStyles.homeTransactionTitle.copyWith(
                                    color: !hasName ? context.colors.delete : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                secondChild: Text(
                                  widget.aiTransaction.name ?? 'voiceAddTitle'.tr(),
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
                                  hasCreatedAt
                                      ? DateFormat(
                                          'HH:mm',
                                          context.locale.languageCode,
                                        ).format(
                                          widget.aiTransaction.createdAt!,
                                        )
                                      : 'voiceAddTime'.tr(),
                                  style: context.textStyles.homeTransactionTime.copyWith(
                                    color: !hasCreatedAt ? context.colors.delete : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                secondChild: Text(
                                  hasCreatedAt
                                      ? DateFormat(
                                          'HH:mm',
                                          context.locale.languageCode,
                                        ).format(
                                          widget.aiTransaction.createdAt!,
                                        )
                                      : 'voiceAddTime'.tr(),
                                  style: context.textStyles.homeTransactionTime.copyWith(
                                    color: !hasCreatedAt ? context.colors.delete : null,
                                  ),
                                ),
                              ),

                              ///
                              /// NOTE
                              ///
                              if (widget.aiTransaction.note?.isNotEmpty ?? false) ...[
                                const SizedBox(height: 2),
                                AnimatedCrossFade(
                                  duration: TroskoDurations.animation,
                                  firstCurve: Curves.easeIn,
                                  secondCurve: Curves.easeIn,
                                  sizeCurve: Curves.easeIn,
                                  crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  firstChild: Text(
                                    widget.aiTransaction.note!,
                                    style: context.textStyles.homeTransactionNote,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  secondChild: Text(
                                    widget.aiTransaction.note!,
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
                                          isDuotone: widget.useColorfulIcons,
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
                                          isDuotone: widget.useColorfulIcons,
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
                            if (hasAmount)
                              Text.rich(
                                TextSpan(
                                  text: formatCentsToCurrency(
                                    widget.aiTransaction.amountCents!,
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
                              )
                            else
                              Text(
                                'voiceAddAmount'.tr(),
                                style: context.textStyles.homeTransactionEuro.copyWith(
                                  color: context.colors.delete,
                                ),
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
