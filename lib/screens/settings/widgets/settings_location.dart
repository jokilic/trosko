import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/durations.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';

class SettingsLocation extends StatelessWidget {
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final String text;

  const SettingsLocation({
    required this.color,
    required this.highlightColor,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 104,
    child: Column(
      children: [
        AnimatedContainer(
          duration: TroskoDurations.animation,
          curve: Curves.easeIn,
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 1.5,
            ),
          ),
          child: IconButton(
            onPressed: null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(12),
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
                    duotoneSecondaryColor: context.colors.buttonPrimary,
                    size: 40,
                  )
                : const SizedBox(
                    height: 40,
                    width: 40,
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
