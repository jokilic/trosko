import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/durations.dart';
import '../../../models/category/category.dart';
import '../../../models/transaction/transaction.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import '../../../util/color.dart';
import '../../../util/currency.dart';
import '../../../util/icons.dart';

class HomeTransactionListTile extends StatefulWidget {
  final Function() onLongPressed;
  final Function() onDeletePressed;
  final Transaction transaction;
  final Category? category;

  const HomeTransactionListTile({
    required this.onLongPressed,
    required this.onDeletePressed,
    required this.transaction,
    required this.category,
  });

  @override
  State<HomeTransactionListTile> createState() => _HomeTransactionListTileState();
}

class _HomeTransactionListTileState extends State<HomeTransactionListTile> {
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
              onLongPress: widget.onLongPressed,
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
                          color: widget.category?.color ?? context.colors.borderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        getBoldIconFromName(
                          widget.category?.iconName,
                        )?.value,
                        color: getBestIconColor(
                          backgroundColor: widget.category?.color ?? context.colors.scaffoldBackground,
                          whiteColor: TroskoColors.lighterGrey,
                          blackColor: TroskoColors.lightDark,
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
                            const SizedBox(height: 4),
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
  );
}
