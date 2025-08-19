import 'package:flutter/material.dart';

import '../../../models/transaction/transaction.dart';
import '../../../theme/theme.dart';
import '../../../util/currency.dart';

class HomeTransactionWidget extends StatelessWidget {
  final Transaction transaction;

  const HomeTransactionWidget({
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
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
    trailing: Text(
      formatCentsToCurrency(
        transaction.amountCents,
      ),
      style: context.textStyles.homeTransactionValue,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
