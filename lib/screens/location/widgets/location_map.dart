import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../services/map_service.dart';
import '../../../theme/extensions.dart';
import '../../../util/icons.dart';

class LocationMap extends StatelessWidget {
  final MapController mapController;
  final LatLng coordinates;
  final Function(MapEvent event) onMapEvent;
  final Function() onMapReady;
  final Style? mapStyle;
  final bool useVectorMaps;

  const LocationMap({
    required this.mapController,
    required this.coordinates,
    required this.onMapEvent,
    required this.onMapReady,
    required this.mapStyle,
    required this.useVectorMaps,
  });

  @override
  Widget build(BuildContext context) => ClipOval(
    child: FlutterMap(
      mapController: mapController,
      options: MapOptions(
        backgroundColor: context.colors.buttonBackground,
        onMapReady: onMapReady,
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
        if (mapStyle != null && useVectorMaps)
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
              width: 20,
              height: 20,
              child: PhosphorIcon(
                getPhosphorIcon(
                  PhosphorIcons.x,
                  isDuotone: false,
                  isBold: false,
                ),
                color: context.colors.buttonPrimary,
                duotoneSecondaryColor: context.colors.buttonPrimary,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
