import 'package:flutter/material.dart';

import '../../../models/category/category.dart';
import '../../../theme/theme.dart';
import '../../../widgets/trosko_button.dart';

class TransactionCategory extends StatelessWidget {
  final Function(Category category) onPressed;
  final Category category;

  const TransactionCategory({
    required this.onPressed,
    required this.category,
  });

  @override
  Widget build(BuildContext context) => TroskoButton(
    onPressed: () => onPressed(category),
    child: SizedBox(
      width: 96,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: category.color,
            ),
            height: 56,
            width: 56,
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: context.textStyles.transactionCategoryName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
