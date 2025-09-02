import 'package:flutter/material.dart';

import '../../../models/category/category.dart';
import '../../../models/transaction/transaction.dart';
import '../../../theme/theme.dart';
import '../../../util/currency.dart';

class HomeTransactionWidget extends StatelessWidget {
  final Function() onPressed;
  final Transaction transaction;
  final Category? category;

  const HomeTransactionWidget({
    required this.onPressed,
    required this.transaction,
    required this.category,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 1,
    ),
    child: ListTile(
      tileColor: context.colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: onPressed,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category?.color,
          border: Border.all(
            color: context.colors.text,
            width: 2.5,
          ),
        ),
        height: 32,
        width: 32,
      ),
      title: Text(
        transaction.name,
        style: context.textStyles.homeTransactionTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: transaction.note?.isNotEmpty ?? false
          ? Text(
              transaction.note!,
              style: context.textStyles.homeTransactionSubtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Text.rich(
        TextSpan(
          text: formatCentsToCurrency(
            transaction.amountCents,
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
  );
}
