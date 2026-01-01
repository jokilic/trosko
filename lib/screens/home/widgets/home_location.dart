import 'dart:ui';

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
  final bool isActive;
  final bool useMap;
  final Style? mapStyle;
  final bool useVectorMaps;

  const HomeLocation({
    required this.location,
    required this.color,
    required this.text,
    required this.isActive,
    required this.useMap,
    required this.useVectorMaps,
    this.coordinates,
    this.icon,
    this.onPressed,
    this.mapStyle,
  });

  @override
  Widget build(BuildContext context) => OpenContainer(
    transitionDuration: TroskoDurations.animationLong,
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
          AnimatedContainer(
            duration: TroskoDurations.animation,
            curve: Curves.easeIn,
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Stack(
                fit: StackFit.expand,
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
                      ],
                    ),

                  ///
                  /// BLUR
                  ///
                  if (useMap)
                    ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 4,
                          sigmaY: 4,
                        ),
                        child: const SizedBox.shrink(),
                      ),
                    ),

                  ///
                  /// ACTIVE MAP
                  ///
                  if (useMap)
                    AnimatedContainer(
                      duration: TroskoDurations.animation,
                      curve: Curves.easeIn,
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isActive ? color : Colors.transparent,
                          width: 6,
                        ),
                        shape: BoxShape.circle,
                      ),
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
                      alignment: Alignment.center,
                    ),
                    icon: icon != null
                        ? PhosphorIcon(
                            icon!,
                            color: useMap
                                ? TroskoColors.lightThemeBlackText
                                : getWhiteOrBlackColor(
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
