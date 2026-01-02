import 'dart:ui';

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
  final IconData? icon;
  final bool isActive;
  final bool useMap;
  final Style? mapStyle;
  final bool useVectorMaps;

  const TransactionLocation({
    required this.onPressed,
    required this.location,
    required this.color,
    required this.isActive,
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
                  onPressed: () => onPressed(location),
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
                          duotoneSecondaryColor: context.colors.buttonPrimary,
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
