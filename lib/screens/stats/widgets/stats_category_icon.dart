import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../models/category/category.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';
import '../../../util/icons.dart';

class StatsCategoryIcon extends StatelessWidget {
  final Category category;
  final bool useColorfulIcons;

  const StatsCategoryIcon({
    required this.category,
    required this.useColorfulIcons,
  });

  @override
  Widget build(BuildContext context) {
    final icon = getPhosphorIconFromName(
      category.iconName,
    );

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: category.color,
        border: Border.all(
          color: category.color,
          width: 1.5,
        ),
      ),
      child: icon != null
          ? PhosphorIcon(
              getPhosphorIcon(
                icon.value,
                isDuotone: useColorfulIcons,
                isBold: true,
              ),
              color: getWhiteOrBlackColor(
                backgroundColor: category.color,
                whiteColor: TroskoColors.lightThemeWhiteBackground,
                blackColor: TroskoColors.lightThemeBlackText,
              ),
              duotoneSecondaryColor: context.colors.buttonPrimary,
              size: 16,
            )
          : null,
    );
  }
}
