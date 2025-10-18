import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../../constants/durations.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import '../../../util/color.dart';

class HomeCategory extends StatelessWidget {
  final Function()? onPressed;
  final Function()? onPressedAdd;
  final Function()? onLongPressed;
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final String text;
  final bool hasBorder;

  const HomeCategory({
    required this.color,
    required this.highlightColor,
    required this.text,
    this.icon,
    this.onPressed,
    this.onPressedAdd,
    this.onLongPressed,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) => OpenContainer(
    transitionDuration: TroskoDurations.switchAnimation,
    middleColor: context.colors.scaffoldBackground,
    openElevation: 0,
    openColor: context.colors.scaffoldBackground,
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
              onPressed: onPressedAdd != null ? openContainer : onPressed,
              onLongPress: onLongPressed != null ? openContainer : null,
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
    openBuilder: (context, _) => onLongPressed != null
        ? onLongPressed!()
        : onPressedAdd != null
        ? onPressedAdd!()
        : null,
  );
}
