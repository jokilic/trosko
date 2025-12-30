import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../models/location/location.dart';
import '../../../services/map_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';

class TransactionLocation extends StatelessWidget {
  final Function(Location location) onPressed;
  final Location location;
  final LatLng? coordinates;
  final Color color;
  final IconData? icon;
  final bool useMap;
  final Style? mapStyle;
  final bool useVectorMaps;

  const TransactionLocation({
    required this.onPressed,
    required this.location,
    required this.color,
    required this.useMap,
    required this.useVectorMaps,
    required super.key,
    this.coordinates,
    this.icon,
    this.mapStyle,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 104,
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 1.5,
            ),
          ),
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ///
                  /// MAP
                  ///
                  if (useMap)
                    FlutterMap(
                      options: MapOptions(
                        onTap: (_, __) => onPressed(location),
                        maxZoom: 21,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                        initialCenter: coordinates!,
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
                              point: coordinates!,
                              width: 20,
                              height: 20,
                              child: PhosphorIcon(
                                PhosphorIcons.xCircle(
                                  PhosphorIconsStyle.bold,
                                ),
                                color: context.colors.buttonPrimary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ///
                  /// BUTTON
                  ///
                  IconButton(
                    onPressed: () => onPressed(location),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      backgroundColor: useMap ? null : color,
                      disabledBackgroundColor: useMap ? null : color,
                      alignment: Alignment.center,
                    ),
                    icon: icon != null && !useMap
                        ? PhosphorIcon(
                            icon!,
                            color: getWhiteOrBlackColor(
                              backgroundColor: color,
                              whiteColor: TroskoColors.lightThemeWhiteBackground,
                              blackColor: TroskoColors.lightThemeBlackText,
                            ),
                            size: 40,
                          )
                        : const SizedBox(
                            height: 40,
                            width: 40,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          location.name,
          style: context.textStyles.transactionCategoryName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
