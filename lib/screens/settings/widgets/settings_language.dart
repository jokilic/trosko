import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class SettingsLanguage extends StatelessWidget {
  final Function() onPressed;
  final String icon;
  final Color highlightColor;
  final IconData? activeIcon;

  const SettingsLanguage({
    required this.onPressed,
    required this.icon,
    required this.highlightColor,
    this.activeIcon,
  });

  @override
  Widget build(BuildContext context) => Container(
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
        padding: EdgeInsets.zero,
        highlightColor: highlightColor,
        alignment: Alignment.center,
      ),
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            icon,
            height: 58,
            width: 58,
          ),

          if (activeIcon != null)
            Icon(
              activeIcon,
              color: context.colors.icon,
              size: 36,
            ),
        ],
      ),
    ),
  );
}
