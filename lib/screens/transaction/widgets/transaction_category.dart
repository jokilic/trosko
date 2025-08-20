import 'package:flutter/material.dart';

import '../../../models/category/category.dart';
import '../../../theme/theme.dart';
import '../../../widgets/trosko_button.dart';

class TransactionCategory extends StatelessWidget {
  final bool isActive;
  final Function(Category category) onPressed;
  final Category category;

  const TransactionCategory({
    required this.isActive,
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
              border: Border.all(
                color: isActive ? context.colors.text : Colors.transparent,
                width: 2.5,
              ),
            ),
            height: 56,
            width: 56,
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: context.textStyles.transactionCategoryName.copyWith(
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
