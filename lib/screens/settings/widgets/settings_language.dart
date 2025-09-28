import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class SettingsLanguage extends StatelessWidget {
  final Function() onPressed;
  final Color highlightColor;
  final String flagIcon;
  final String text;
  final double circleOpacity;

  const SettingsLanguage({
    required this.onPressed,
    required this.flagIcon,
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
                padding: EdgeInsets.zero,
                highlightColor: highlightColor,
                alignment: Alignment.center,
              ),
              icon: Image.asset(
                flagIcon,
                height: 56,
                width: 56,
              ),
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
