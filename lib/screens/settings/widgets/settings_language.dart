import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class SettingsLanguage extends StatelessWidget {
  final Function() onPressed;
  final Color highlightColor;
  final String flagIcon;
  final IconData? icon;
  final String text;
  final double circleOpacity;

  const SettingsLanguage({
    required this.onPressed,
    required this.flagIcon,
    required this.highlightColor,
    required this.text,
    required this.circleOpacity,
    this.icon,
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
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    flagIcon,
                    height: 60,
                    width: 60,
                  ),

                  Icon(
                    icon,
                    color: context.colors.icon,
                    size: 40,
                  ),
                ],
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
