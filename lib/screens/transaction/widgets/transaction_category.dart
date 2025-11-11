import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../models/category/category.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';

class TransactionCategory extends StatelessWidget {
  final Function(Category category) onPressed;
  final Category category;
  final Color color;
  final Color highlightColor;
  final IconData? icon;

  const TransactionCategory({
    required this.onPressed,
    required this.category,
    required this.color,
    required this.highlightColor,
    required super.key,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 80,
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 1.5,
            ),
          ),
          child: IconButton(
            onPressed: () => onPressed(category),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(12),
              backgroundColor: color,
              highlightColor: highlightColor,
              alignment: Alignment.center,
            ),
            icon: icon != null
                ? PhosphorIcon(
                    icon!,
                    color: getWhiteOrBlackColor(
                      backgroundColor: color,
                      whiteColor: TroskoColors.lightThemeWhiteBackground,
                      blackColor: TroskoColors.lightThemeBlackText,
                    ),
                    size: 36,
                  )
                : const SizedBox(
                    height: 36,
                    width: 36,
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          category.name,
          style: context.textStyles.transactionCategoryName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
