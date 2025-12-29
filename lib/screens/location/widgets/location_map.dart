import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

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
        // TODO: Tweak this
        initialZoom: 12,
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
            // TODO: Tweak this
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            maxZoom: 21,
            userAgentPackageName: 'com.josipkilic.trosko',
          ),

        ///
        /// MARKER
        ///
        MarkerLayer(
          markers: [
            // TODO: Tweak this
            Marker(
              point: coordinates,
              width: 20,
              height: 20,
              child: Container(
                height: 24,
                width: 24,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
