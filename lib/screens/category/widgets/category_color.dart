import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class CategoryColor extends StatelessWidget {
  final Function() onPressed;
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final bool hasBorder;

  const CategoryColor({
    required this.onPressed,
    required this.color,
    required this.highlightColor,
    this.hasBorder = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: hasBorder ? context.colors.borderColor : color,
        width: 1.5,
      ),
    ),
    child: IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(8),
        backgroundColor: color,
        highlightColor: highlightColor,
        alignment: Alignment.center,
      ),
      icon: Icon(
        icon,
        color: context.colors.icon,
        size: 24,
      ),
    ),
  );
}
