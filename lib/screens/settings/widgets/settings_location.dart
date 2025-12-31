import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../constants/durations.dart';
import '../../../services/map_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';

class SettingsLocation extends StatelessWidget {
  final LatLng? coordinates;
  final Color color;
  final IconData? icon;
  final bool useMap;
  final Style? mapStyle;
  final bool useVectorMaps;
  final String text;

  const SettingsLocation({
    required this.useVectorMaps,
    required this.color,
    required this.text,
    required this.useMap,
    this.coordinates,
    this.icon,
    this.mapStyle,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 104,
    child: Column(
      children: [
        AnimatedContainer(
          duration: TroskoDurations.animation,
          curve: Curves.easeIn,
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: IgnorePointer(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ///
                  /// MAP
                  ///
                  if (useMap)
                    FlutterMap(
                      options: MapOptions(
                        backgroundColor: context.colors.buttonBackground,
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
                              width: 16,
                              height: 16,
                              child: PhosphorIcon(
                                PhosphorIcons.x(
                                  PhosphorIconsStyle.bold,
                                ),
                                color: context.colors.buttonPrimary,
                                size: 16,
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
                    onPressed: null,
                    style: IconButton.styleFrom(
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
