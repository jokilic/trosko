import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/durations.dart';
import '../../../models/location/location.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';
import '../../location/location_screen.dart';

class HomeLocation extends StatelessWidget {
  final Location? location;
  final Function()? onPressed;
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final String text;
  final bool hasBorder;

  const HomeLocation({
    required this.location,
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
                disabledBackgroundColor: color,
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
    ),
    openBuilder: (context, _) => LocationScreen(
      passedLocation: location,
      key: ValueKey(location?.id),
    ),
  );
}
