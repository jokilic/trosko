import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../models/location/location.dart';
import '../../../theme/extensions.dart';
import '../../../util/icons.dart';
import 'settings_location.dart';

class SettingsLocations extends StatelessWidget {
  final List<Location> locations;
  final void Function(List<Location> newOrder) onReorderLocations;
  final Style? mapStyle;
  final bool useVectorMaps;

  const SettingsLocations({
    required this.locations,
    required this.onReorderLocations,
    required this.useVectorMaps,
    this.mapStyle,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(
      height: 136,
      child: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        itemCount: locations.length,
        onReorder: (oldIndex, newIndex) {
          if (newIndex > locations.length) {
            newIndex = locations.length;
          }

          final list = List<Location>.from(locations);

          if (newIndex > oldIndex) {
            newIndex -= 1;
          }

          final item = list.removeAt(oldIndex);
          list.insert(newIndex, item);

          onReorderLocations(list);
        },
        proxyDecorator: (child, _, __) => Material(
          borderRadius: BorderRadius.circular(8),
          color: context.colors.listTileBackground,
          child: child,
        ),
        itemBuilder: (_, index) {
          final location = locations[index];

          final locationCoordinates = location.latitude != null && location.longitude != null
              ? LatLng(
                  location.latitude!,
                  location.longitude!,
                )
              : null;

          final icon = getPhosphorIconFromName(location.iconName)?.value;

          return ReorderableDelayedDragStartListener(
            key: ValueKey(location.id),
            index: index,
            child: SettingsLocation(
              coordinates: locationCoordinates,
              useMap: locationCoordinates != null,
              mapStyle: mapStyle,
              useVectorMaps: useVectorMaps,
              color: context.colors.buttonBackground,
              text: location.name,
              icon: icon != null
                  ? getPhosphorIcon(
                      icon,
                      isDuotone: false,
                      isBold: false,
                    )
                  : null,
            ),
          );
        },
      ),
    ),
  );
}
