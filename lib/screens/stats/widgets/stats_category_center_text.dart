import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../models/category/category.dart';
import '../../../theme/extensions.dart';
import '../../../util/currency.dart';

class StatsCategoryCenterText extends StatelessWidget {
  final Category category;
  final int amount;

  const StatsCategoryCenterText({
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: 96,
    height: 96,
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ///
        /// TITLE
        ///
        Text(
          category.name,
          style: context.textStyles.homeTransactionTitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        ///
        /// AMOUNT
        ///
        Text.rich(
          TextSpan(
            text: formatCentsToCurrency(
              amount,
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
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
