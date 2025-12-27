import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/durations.dart';
import '../../../models/location/location.dart';
import '../../../theme/extensions.dart';
import 'home_location.dart';

class HomeLocations extends StatelessWidget {
  final bool isExpanded;
  final List<Location> locations;
  final List<Location>? activeLocations;
  final void Function(List<Location> newOrder) onReorderLocations;
  final void Function(Location location) onPressedLocation;

  const HomeLocations({
    required this.isExpanded,
    required this.locations,
    required this.activeLocations,
    required this.onReorderLocations,
    required this.onPressedLocation,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 104,
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

          return Animate(
            key: ValueKey(isExpanded),
            effects: const [
              ScaleEffect(
                curve: Curves.easeIn,
                duration: TroskoDurations.animation,
              ),
            ],
            child: HomeLocation(
              location: location,
              onPressed: () => onPressedLocation(location),
              color: Colors.green,
              highlightColor: Colors.green.withValues(alpha: 0.2),
              text: 'Hello',
              // color: location.color.withValues(
              //   alpha: (activeCategories?.isEmpty ?? true) || (activeCategories?.contains(category) ?? false) ? 1 : 0.2,
              // ),
              // highlightColor: category.color.withValues(alpha: 0.2),
              // icon: getRegularIconFromName(category.iconName)?.value,
              // text: category.name,
            ),
          );
        }

        ///
        /// ADD LOCATION
        ///
        return HomeLocation(
          location: null,
          color: context.colors.buttonBackground,
          highlightColor: context.colors.listTileBackground,
          icon: PhosphorIcons.plus(),
          text: 'homeAdd'.tr(),
          hasBorder: false,
        );
      },
    ),
  );
}
