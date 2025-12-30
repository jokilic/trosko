import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/location/location.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../services/map_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/color.dart';
import '../../util/dependencies.dart';
import '../../widgets/icon_list_tile.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_text_field.dart';
import 'location_controller.dart';
import 'widgets/location_map.dart';

class LocationScreen extends WatchingStatefulWidget {
  final Location? passedLocation;

  const LocationScreen({
    required this.passedLocation,
    required super.key,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<LocationController>(
      () => LocationController(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
        firebase: getIt.get<FirebaseService>(),
        passedLocation: widget.passedLocation,
      ),
      instanceName: widget.passedLocation?.id,
      afterRegister: (controller) => WidgetsBinding.instance.addPostFrameCallback(
        (_) => controller.init(
          locale: context.locale.languageCode,
        ),
      ),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<LocationController>(
      instanceName: widget.passedLocation?.id,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationController = getIt.get<LocationController>(
      instanceName: widget.passedLocation?.id,
    );

    final state = watchIt<LocationController>(
      instanceName: widget.passedLocation?.id,
    ).value;

    final mapState = watchIt<MapService>().value;

    final useVectorMaps = watchIt<HiveService>().value.settings?.useVectorMaps ?? false;

    final locationName = state.locationName;

    final locationLatitude = state.latitude;
    final locationLongitude = state.longitude;

    final locationIcon = state.locationIcon;

    final searchedIcons = state.searchedIcons;

    final locationCoordinates = locationLatitude != null && locationLongitude != null
        ? LatLng(
            locationLatitude,
            locationLongitude,
          )
        : null;

    final mapEditMode = state.mapEditMode;

    final validated = state.nameValid;

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          ///
          /// APP BAR
          ///
          TroskoAppBar(
            leadingWidget: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                highlightColor: context.colors.buttonBackground,
              ),
              icon: PhosphorIcon(
                PhosphorIcons.arrowLeft(
                  PhosphorIconsStyle.bold,
                ),
                color: context.colors.text,
                size: 28,
              ),
            ),
            actionWidgets: [
              if (widget.passedLocation != null)
                IconButton(
                  onPressed: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );
                    await locationController.deleteLocation();
                    Navigator.of(context).pop();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    highlightColor: context.colors.buttonBackground,
                  ),
                  icon: PhosphorIcon(
                    PhosphorIcons.trash(
                      PhosphorIconsStyle.bold,
                    ),
                    color: context.colors.delete,
                    size: 28,
                  ),
                ),
            ],
            smallTitle: widget.passedLocation != null ? 'locationUpdateTitle'.tr() : 'locationNewTitle'.tr(),
            bigTitle: widget.passedLocation != null ? 'locationUpdateTitle'.tr() : 'locationNewTitle'.tr(),
            bigSubtitle: widget.passedLocation != null ? 'locationUpdateSubtitle'.tr() : 'locationNewSubtitle'.tr(),
          ),

          ///
          /// CONTENT
          ///
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 8),

                ///
                /// LOCATION
                ///
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        locationController.mapEditModeChanged();
                      },
                      child: Stack(
                        children: [
                          ///
                          /// MAP
                          ///
                          Container(
                            height: 280,
                            width: 280,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.colors.text,
                                width: 1.5,
                              ),
                            ),
                            child: locationCoordinates != null
                                ? IgnorePointer(
                                    ignoring: !mapEditMode,
                                    child: LocationMap(
                                      mapStyle: mapState,
                                      useVectorMaps: useVectorMaps,
                                      mapController: locationController.mapController,
                                      coordinates: locationCoordinates,
                                      onMapEvent: locationController.onMapEvent,
                                      onMapReady: () => locationController.mapReady = true,
                                    ),
                                  )
                                : locationIcon != null
                                ? PhosphorIcon(
                                    locationIcon.value,
                                    color: context.colors.text,
                                    size: 104,
                                  )
                                : null,
                          ),

                          ///
                          /// EDIT MODE
                          ///
                          if (mapEditMode)
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: PhosphorIcon(
                                PhosphorIcons.arrowsOutCardinal(),
                                color: context.colors.text,
                                size: 24,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      locationName ?? '',
                      style: context.textStyles.categoryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                ///
                /// LOCATION TITLE & NOTE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'locationTitleNote'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// TITLE TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    controller: locationController.nameTextEditingController,
                    labelText: 'locationTitle'.tr(),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// NOTE TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    controller: locationController.noteTextEditingController,
                    labelText: 'locationNote'.tr(),
                    keyboardType: TextInputType.multiline,
                    minLines: null,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// LOCATION ADDRESS
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'locationAddress'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// ADDRESS TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    onSubmitted: locationController.onAddressSubmitted,
                    controller: locationController.addressTextEditingController,
                    labelText: 'locationAddress'.tr(),
                    keyboardType: TextInputType.streetAddress,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'locationAddressText1'.tr(),
                    style: context.textStyles.homeTransactionNote,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'locationAddressText2'.tr(),
                    style: context.textStyles.homeTransactionNote,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'locationAddressText3'.tr(),
                    style: context.textStyles.homeTransactionNote,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// ICON TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'categoryLocationIcon'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// LOCATION ICON TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    controller: locationController.iconTextEditingController,
                    labelText: 'categoryLocationIcon'.tr(),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 20),

                ///
                /// LOCATION ICONS
                ///
                if (searchedIcons?.isNotEmpty ?? false)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.colors.listTileBackground,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: searchedIcons?.length,
                      itemBuilder: (_, index) {
                        final icon = searchedIcons![index];

                        return IconListTile(
                          isActive: locationIcon?.key == icon.key,
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            locationController.iconChanged(icon);
                          },
                          icon: icon,
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: validated
                ? () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );
                    await locationController.addLocation();
                    Navigator.of(context).pop();
                  }
                : null,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.fromLTRB(
                24,
                28,
                24,
                MediaQuery.paddingOf(context).bottom + 12,
              ),
              backgroundColor: context.colors.buttonPrimary,
              foregroundColor: getWhiteOrBlackColor(
                backgroundColor: context.colors.buttonPrimary,
                whiteColor: TroskoColors.lightThemeWhiteBackground,
                blackColor: TroskoColors.lightThemeBlackText,
              ),
              overlayColor: context.colors.buttonBackground,
              disabledBackgroundColor: context.colors.disabledBackground,
              disabledForegroundColor: context.colors.disabledText,
            ),
            child: Text(
              widget.passedLocation != null ? 'locationUpdateButton'.tr().toUpperCase() : 'locationAddButton'.tr().toUpperCase(),
            ),
          ),
        ),
      ),
    );
  }
}
