import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
  final PhosphorIconData? icon;
  final String text;

  const HomeCategory({
    required this.category,
    required this.color,
    required this.highlightColor,
    required this.text,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 80,
    child: Column(
      children: [
        AnimatedContainer(
          duration: TroskoDurations.animation,
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            color: color,
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
                showCupertinoSheet(
                  context: context,
                  scrollableBuilder: (context, scrollController) => CategoryScreen(
                    scrollController: scrollController,
                    passedCategory: category,
                    key: ValueKey(category?.id),
                  ),
                );
              }
            },
            onLongPress: onPressed != null
                ? () => showCupertinoSheet(
                    context: context,
                    scrollableBuilder: (context, scrollController) => CategoryScreen(
                      scrollController: scrollController,
                      passedCategory: category,
                      key: ValueKey(category?.id),
                    ),
                  )
                : null,
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
                    size: 36,
                  )
                : const SizedBox(
                    height: 36,
                    width: 36,
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
