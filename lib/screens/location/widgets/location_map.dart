import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatelessWidget {
  final LatLng coordinates;

  const LocationMap({
    required this.coordinates,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ClipOval(
    child: FlutterMap(
      options: MapOptions(
        initialCenter: coordinates,
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.josipkilic.trosko',
        ),
      ],
    ),
  );
}
