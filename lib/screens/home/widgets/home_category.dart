import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../../constants/durations.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import '../../../util/color.dart';

class HomeCategory extends StatelessWidget {
  final Function() onPressed;
  final Function()? onLongPressed;
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final String text;
  final bool hasBorder;

  const HomeCategory({
    required this.onPressed,
    required this.color,
    required this.highlightColor,
    required this.text,
    this.icon,
    this.onLongPressed,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) => OpenContainer(
    transitionDuration: TroskoDurations.switchScreenAnimation,
    middleColor: Colors.transparent,
    openElevation: 0,
    openColor: Colors.transparent,
    openShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    closedElevation: 0,
    closedColor: context.colors.scaffoldBackground,
    closedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    closedBuilder: (context, openContainer) => SizedBox(
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
              onPressed: onPressed,
              onLongPress: openContainer,
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(12),
                backgroundColor: color,
                highlightColor: highlightColor,
                alignment: Alignment.center,
              ),
              icon: Icon(
                icon,
                color: getWhiteOrBlackColor(
                  backgroundColor: color,
                  whiteColor: TroskoColors.lighterGrey,
                  blackColor: TroskoColors.black,
                ),
                size: 36,
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
    ),
    openBuilder: (context, _) => onLongPressed != null ? onLongPressed!() : null,
  );
}
