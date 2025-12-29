import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ClipOval(
    child: FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(
          51.509364,
          -0.128928,
        ),
        initialZoom: 9.2,
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
