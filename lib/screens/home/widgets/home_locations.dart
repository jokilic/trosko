import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

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
  final Style? mapStyle;

  const HomeLocations({
    required this.isExpanded,
    required this.locations,
    required this.activeLocations,
    required this.onReorderLocations,
    required this.onPressedLocation,
    this.mapStyle,
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

          final locationCoordinates = location.latitude != null && location.longitude != null
              ? LatLng(
                  location.latitude!,
                  location.longitude!,
                )
              : null;

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
              coordinates: locationCoordinates,
              mapStyle: mapStyle,
              onPressed: () => onPressedLocation(location),
              opacity: (activeLocations?.contains(location) ?? false) ? 1 : 0.4,
              color: context.colors.buttonBackground,
              highlightColor: context.colors.listTileBackground,
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
            icon: PhosphorIcons.plus(
              PhosphorIconsStyle.light,
            ),
            text: 'homeAdd'.tr(),
          ),
        );
      },
    ),
  );
}
