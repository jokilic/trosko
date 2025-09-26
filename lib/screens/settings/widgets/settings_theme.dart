import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class SettingsTheme extends StatelessWidget {
  final Function() onPressed;
  final Color color;
  final Color highlightColor;
  final IconData? icon;

  const SettingsTheme({
    required this.onPressed,
    required this.color,
    required this.highlightColor,
    this.icon,
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
  );
}

class SettingsSystemTheme extends StatelessWidget {
  final Function() onPressed;
  final Color iconColor;
  final Color highlightColor;
  final IconData? icon;

  const SettingsSystemTheme({
    required this.onPressed,
    required this.iconColor,
    required this.highlightColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          TroskoTheme.light.scaffoldBackgroundColor,
          TroskoTheme.light.scaffoldBackgroundColor,
          TroskoTheme.dark.scaffoldBackgroundColor,
          TroskoTheme.dark.scaffoldBackgroundColor,
        ],
        stops: const [0.0, 0.5, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
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
        backgroundColor: Colors.transparent,
        highlightColor: highlightColor,
        alignment: Alignment.center,
      ),
      icon: Icon(
        icon,
        color: iconColor,
        size: 36,
      ),
    ),
  );
}
