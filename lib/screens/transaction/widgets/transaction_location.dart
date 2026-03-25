import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/durations.dart';
import '../../../models/location/location.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';

class TransactionLocation extends StatelessWidget {
  final Function(Location location) onPressed;
  final Location location;
  final Color color;
  final Color highlightColor;
  final IconData? icon;

  const TransactionLocation({
    required this.onPressed,
    required this.location,
    required this.color,
    required this.highlightColor,
    required super.key,
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
            onPressed: () => onPressed(location),
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
          location.name,
          style: context.textStyles.transactionCategoryName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
