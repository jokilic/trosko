import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class TransactionDateCheckbox extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function() onPressed;

  const TransactionDateCheckbox({
    required this.title,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: context.colors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
    ),
    child: Row(
      children: [
        Container(
          height: 24,
          width: 24,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.colors.text,
              width: 2,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? context.colors.text : null,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: context.textStyles.transactionDateText,
        ),
      ],
    ),
  );
}
