import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../theme/theme.dart';

class SettingsTheme extends StatelessWidget {
  final Function() onPressed;
  final Color color;
  final Color highlightColor;
  final String text;
  final double circleOpacity;

  const SettingsTheme({
    required this.onPressed,
    required this.color,
    required this.highlightColor,
    required this.text,
    required this.circleOpacity,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 80,
    child: Column(
      children: [
        Opacity(
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
                padding: const EdgeInsets.all(28),
                backgroundColor: color,
                highlightColor: highlightColor,
                alignment: Alignment.center,
              ),
              icon: const SizedBox.shrink(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: context.textStyles.homeCategoryTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class SettingsSystemTheme extends StatelessWidget {
  final Function() onPressed;
  final Color highlightColor;
  final String text;
  final double circleOpacity;

  const SettingsSystemTheme({
    required this.onPressed,
    required this.highlightColor,
    required this.text,
    required this.circleOpacity,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 80,
    child: Column(
      children: [
        Opacity(
          opacity: circleOpacity,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  TroskoColors.lightGrey,
                  TroskoColors.lightGrey,
                  TroskoColors.dark,
                  TroskoColors.dark,
                ],
                stops: [0.0, 0.5, 0.5, 1.0],
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
                padding: const EdgeInsets.all(28),
                highlightColor: highlightColor,
                alignment: Alignment.center,
              ),
              icon: const SizedBox.shrink(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: context.textStyles.homeCategoryTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
