import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';
import '../../../util/icons.dart';

class StatsIconWidget extends StatelessWidget {
  final String? iconName;
  final Color color;
  final bool useColorfulIcons;

  const StatsIconWidget({
    required this.iconName,
    required this.color,
    required this.useColorfulIcons,
  });

  @override
  Widget build(BuildContext context) {
    final icon = getPhosphorIconFromName(iconName);

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: color,
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
                backgroundColor: color,
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
