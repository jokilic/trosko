import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../constants/durations.dart';
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
  final Color highlightColor;
  final IconData? icon;
  final Style? mapStyle;
  final bool useVectorMaps;
  final double opacity;

  const TransactionLocation({
    required this.onPressed,
    required this.location,
    required this.color,
    required this.highlightColor,
    required this.useVectorMaps,
    required super.key,
    this.coordinates,
    this.icon,
    this.mapStyle,
    this.opacity = 1,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 112,
    child: Column(
      children: [
        AnimatedOpacity(
          opacity: opacity,
          duration: TroskoDurations.animation,
          curve: Curves.easeIn,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 1.5,
              ),
            ),
            child: coordinates != null
                ? Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: FlutterMap(
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
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => onPressed(location),
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        backgroundColor: color,
                        highlightColor: highlightColor,
                        alignment: Alignment.center,
                      ),
                      icon: icon != null
                          ? PhosphorIcon(
                              icon!,
                              color: getWhiteOrBlackColor(
                                backgroundColor: color,
                                whiteColor: TroskoColors.lightThemeWhiteBackground,
                                blackColor: TroskoColors.lightThemeBlackText,
                              ),
                              size: 64,
                            )
                          : const SizedBox(
                              height: 64,
                              width: 64,
                            ),
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
