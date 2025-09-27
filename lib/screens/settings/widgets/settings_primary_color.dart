import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class SettingsPrimaryColor extends StatelessWidget {
  final Function() onPressed;
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final double circleOpacity;

  const SettingsPrimaryColor({
    required this.onPressed,
    required this.color,
    required this.highlightColor,
    required this.circleOpacity,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 60,
    child: Opacity(
      opacity: circleOpacity,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: context.colors.borderColor,
            width: 1.5,
          ),
        ),
        child: IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(12),
            backgroundColor: color,
            highlightColor: highlightColor,
            alignment: Alignment.center,
          ),
          icon: Icon(
            icon,
            color: context.colors.icon,
            size: 36,
          ),
        ),
      ),
    ),
  );
}
