import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';
import '../../../util/icons.dart';

class CategoryColor extends StatelessWidget {
  final Function() onPressed;
  final Color color;
  final Color highlightColor;
  final PhosphorIconData Function([PhosphorIconsStyle])? icon;
  final bool useColorfulIcons;

  const CategoryColor({
    required this.onPressed,
    required this.color,
    required this.highlightColor,
    required this.useColorfulIcons,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: color,
        width: 1.5,
      ),
    ),
    child: IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(8),
        backgroundColor: color,
        highlightColor: highlightColor,
        alignment: Alignment.center,
      ),
      icon: icon != null
          ? PhosphorIcon(
              getPhosphorIcon(
                icon!,
                isDuotone: useColorfulIcons,
                isBold: false,
              ),
              color: getWhiteOrBlackColor(
                backgroundColor: color,
                whiteColor: TroskoColors.lightThemeWhiteBackground,
                blackColor: TroskoColors.lightThemeBlackText,
              ),
              duotoneSecondaryColor: context.colors.buttonPrimary,
              size: 28,
            )
          : const SizedBox(
              height: 28,
              width: 28,
            ),
    ),
  );
}
