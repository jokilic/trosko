import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../services/map_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';

class SettingsLocation extends StatelessWidget {
  final LatLng? coordinates;
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final Style? mapStyle;
  final bool useVectorMaps;
  final String text;

  const SettingsLocation({
    required this.useVectorMaps,
    required this.color,
    required this.highlightColor,
    required this.text,
    this.coordinates,
    this.icon,
    this.mapStyle,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 112,
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
                    child: IgnorePointer(
                      child: FlutterMap(
                        options: MapOptions(
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
                  ),
                )
              : IconButton(
                  onPressed: null,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: color,
                    disabledBackgroundColor: color,
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
        const SizedBox(height: 6),
        Text(
          text,
          style: context.textStyles.homeCategoryTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
