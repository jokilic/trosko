import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/durations.dart';
import '../../../models/location/location.dart';
import '../../../theme/extensions.dart';
import '../../../util/icons.dart';
import 'home_location.dart';

class HomeLocations extends StatelessWidget {
  final bool isExpanded;
  final List<Location> locations;
  final List<Location>? activeLocations;
  final void Function(List<Location> newOrder) onReorderLocations;
  final void Function(Location location) onPressedLocation;
  final bool useColorfulIcons;

  const HomeLocations({
    required this.isExpanded,
    required this.locations,
    required this.activeLocations,
    required this.onReorderLocations,
    required this.onPressedLocation,
    required this.useColorfulIcons,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 136,
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: locations.length + 1,
      itemBuilder: (_, index) {
        ///
        /// LOCATION
        ///
        if (index < locations.length) {
          final location = locations[index];
          final icon = getPhosphorIconFromName(location.iconName)?.value;

          return Animate(
            key: ValueKey(isExpanded),
            effects: [
              if (isExpanded)
                const ScaleEffect(
                  curve: Curves.easeIn,
                  duration: TroskoDurations.animation,
                ),
            ],
            child: HomeLocation(
              location: location,
              onPressed: () => onPressedLocation(location),
              color: location.color.withValues(
                alpha: (activeLocations?.isEmpty ?? true) || (activeLocations?.contains(location) ?? false) ? 1 : 0.2,
              ),
              highlightColor: location.color.withValues(alpha: 0.2),
              icon: icon != null
                  ? getPhosphorIcon(
                      icon,
                      isDuotone: useColorfulIcons,
                      isBold: false,
                    )
                  : null,
              text: location.name,
            ),
          );
        }

        ///
        /// ADD LOCATION
        ///
        return Animate(
          key: ValueKey(isExpanded),
          effects: [
            if (isExpanded)
              const ScaleEffect(
                curve: Curves.easeIn,
                duration: TroskoDurations.animation,
              ),
          ],
          child: HomeLocation(
            location: null,
            color: context.colors.buttonBackground,
            highlightColor: context.colors.listTileBackground,
            icon: getPhosphorIcon(
              PhosphorIcons.plus,
              isDuotone: useColorfulIcons,
              isBold: false,
            ),
            text: 'homeAdd'.tr(),
          ),
        );
      },
    ),
  );
}
