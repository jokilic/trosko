import 'package:flutter/material.dart';

import '../../../models/category/category.dart';
import '../../../models/transaction/transaction.dart';
import '../../../theme/theme.dart';
import '../../../util/currency.dart';

class HomeTransactionWidget extends StatelessWidget {
  final Transaction transaction;
  final Category? category;

  const HomeTransactionWidget({
    required this.transaction,
    required this.category,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: category?.color,
        border: Border.all(
          color: context.colors.text,
          width: 2.5,
        ),
      ),
      height: 24,
      width: 24,
    ),
    title: Text(
      transaction.name,
      style: context.textStyles.homeTransactionTitle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      transaction.note ?? '--',
      style: context.textStyles.homeTransactionSubtitle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
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
  );
}
