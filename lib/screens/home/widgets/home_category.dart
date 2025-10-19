import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/durations.dart';
import '../../../models/category/category.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';
import '../../category/category_screen.dart';

class HomeCategory extends StatelessWidget {
  final Category? category;
  final Function()? onPressed;
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final String text;
  final bool hasBorder;

  const HomeCategory({
    required this.category,
    required this.color,
    required this.highlightColor,
    required this.text,
    this.icon,
    this.onPressed,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) => OpenContainer(
    transitionDuration: TroskoDurations.switchAnimation,
    transitionType: ContainerTransitionType.fadeThrough,
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
              onPressed: () {
                if (onPressed != null) {
                  onPressed!();
                } else {
                  HapticFeedback.lightImpact();
                  openContainer();
                }
              },
              onLongPress: onPressed != null ? openContainer : null,
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
    openBuilder: (context, _) => CategoryScreen(
      passedCategory: category,
      key: ValueKey(category?.id),
    ),
  );
}
