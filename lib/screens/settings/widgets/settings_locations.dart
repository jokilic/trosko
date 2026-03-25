import 'package:flutter/material.dart';

import '../../../models/location/location.dart';
import '../../../theme/extensions.dart';
import '../../../util/icons.dart';
import 'settings_location.dart';

class SettingsLocations extends StatelessWidget {
  final List<Location> locations;
  final void Function(List<Location> newOrder) onReorderLocations;
  final bool useColorfulIcons;

  const SettingsLocations({
    required this.locations,
    required this.onReorderLocations,
    required this.useColorfulIcons,
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
          var index = newIndex;

          if (index > locations.length) {
            index = locations.length;
          }

          final list = List<Location>.from(locations);

          if (index > oldIndex) {
            index -= 1;
          }

          final item = list.removeAt(oldIndex);
          list.insert(index, item);

          onReorderLocations(list);
        },
        proxyDecorator: (child, _, __) => Material(
          borderRadius: BorderRadius.circular(8),
          color: context.colors.listTileBackground,
          child: child,
        ),
        itemBuilder: (_, index) {
          final location = locations[index];
          final icon = getPhosphorIconFromName(location.iconName)?.value;

          return ReorderableDelayedDragStartListener(
            key: ValueKey(location.id),
            index: index,
            child: SettingsLocation(
              color: location.color,
              highlightColor: location.color,
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
        },
      ),
    ),
  );
}
