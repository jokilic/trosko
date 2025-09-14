import 'package:flutter/material.dart';

import '../../../constants/durations.dart';
import '../../../models/category/category.dart';
import '../../../models/transaction/transaction.dart';
import '../../../theme/theme.dart';
import '../../../util/currency.dart';

class HomeTransactionListTile extends StatefulWidget {
  final Function() onLongPressed;
  final Transaction transaction;
  final Category? category;

  const HomeTransactionListTile({
    required this.onLongPressed,
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
    duration: TroskoDurations.animationDuration,
    curve: Curves.easeIn,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 1,
      ),
      child: ListTile(
        tileColor: context.colors.listTileBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: toggleExpanded,
        onLongPress: widget.onLongPressed,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.category?.color,
            border: Border.all(
              color: context.colors.text,
              width: 2.5,
            ),
          ),
          height: 32,
          width: 32,
        ),
        title: Text(
          widget.transaction.name,
          style: context.textStyles.homeTransactionTitle,
          maxLines: expanded ? null : 1,
          overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        subtitle: widget.transaction.note?.isNotEmpty ?? false
            ? Text(
                widget.transaction.note!,
                style: context.textStyles.homeTransactionSubtitle,
                maxLines: expanded ? null : 1,
                overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              )
            : null,
        trailing: Text.rich(
          TextSpan(
            text: formatCentsToCurrency(
              widget.transaction.amountCents,
            ),
            children: [
              TextSpan(
                text: '€',
                style: context.textStyles.homeTransactionEuro,
              ),
            ],
          ),
          style: context.textStyles.homeTransactionValue,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}
