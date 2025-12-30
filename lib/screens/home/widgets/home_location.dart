import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../location/location_screen.dart';

class HomeLocation extends StatelessWidget {
  final Location? location;
  final LatLng? coordinates;
  final Function()? onPressed;
  final Color color;
  final IconData? icon;
  final String text;
  final bool useMap;
  final Style? mapStyle;
  final bool useVectorMaps;

  const HomeLocation({
    required this.location,
    required this.color,
    required this.text,
    required this.useMap,
    required this.useVectorMaps,
    this.coordinates,
    this.icon,
    this.onPressed,
    this.mapStyle,
  });

  @override
  Widget build(BuildContext context) => OpenContainer(
    transitionDuration: TroskoDurations.switchAnimation,
    transitionType: ContainerTransitionType.fadeThrough,
    middleColor: context.colors.scaffoldBackground,
    openElevation: 0,
    openColor: context.colors.scaffoldBackground,
    openShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    closedElevation: 0,
    closedColor: context.colors.scaffoldBackground,
    closedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    closedBuilder: (context, openContainer) => SizedBox(
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
                      onPressed: () {
                        if (onPressed != null) {
                          onPressed!();
                        } else {
                          HapticFeedback.lightImpact();
                          openContainer();
                        }
                      },
                      onLongPress: onPressed != null ? openContainer : null,
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
            text,
            style: context.textStyles.homeCategoryTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    openBuilder: (context, _) => LocationScreen(
      passedLocation: location,
      key: ValueKey(location?.id),
    ),
  );
}
