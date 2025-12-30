import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../services/map_service.dart';
import '../../../theme/extensions.dart';

class LocationMap extends StatelessWidget {
  final MapController mapController;
  final LatLng coordinates;
  final Function(MapEvent event)? onMapEvent;
  final Style? mapStyle;

  const LocationMap({
    required this.mapController,
    required this.coordinates,
    required this.onMapEvent,
    required this.mapStyle,
  });

  @override
  Widget build(BuildContext context) => ClipOval(
    child: FlutterMap(
      mapController: mapController,
      options: MapOptions(
        maxZoom: 21,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onMapEvent: onMapEvent,
        initialCenter: coordinates,
        initialZoom: 16,
      ),
      children: [
        ///
        /// MAP VECTOR
        ///
        if (mapStyle != null)
          VectorTileLayer(
            tileProviders: mapStyle!.providers,
            theme: mapStyle!.theme,
            tileOffset: TileOffset.mapbox,
          )
        ///
        /// FALLBACK MAP
        ///
        else
          TileLayer(
            urlTemplate: openStreetMapUri,
            maxZoom: 21,
            maxNativeZoom: 21,
            userAgentPackageName: 'com.josipkilic.trosko',
          ),

        ///
        /// MARKER
        ///
        MarkerLayer(
          markers: [
            Marker(
              point: coordinates,
              width: 26,
              height: 26,
              child: PhosphorIcon(
                PhosphorIcons.xCircle(
                  PhosphorIconsStyle.bold,
                ),
                color: context.colors.delete,
                size: 26,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
