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
  final double opacity;
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final String text;
  final Style? mapStyle;

  const HomeLocation({
    required this.location,
    required this.color,
    required this.highlightColor,
    required this.text,
    this.coordinates,
    this.icon,
    this.onPressed,
    this.mapStyle,
    this.opacity = 1,
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
              child: location != null && coordinates != null
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
                            onTap: (_, __) {
                              if (onPressed != null) {
                                onPressed!();
                              } else {
                                HapticFeedback.lightImpact();
                                openContainer();
                              }
                            },
                            onLongPress: onPressed != null ? (_, __) => openContainer() : null,
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
                  : IconButton(
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
