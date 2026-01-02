import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/location/location.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../util/icons.dart';

/// Class to distinguish `no argument passed` from `explicitly passed null`
class LocationStateNoChange {
  const LocationStateNoChange();
}

const locationStateNoChange = LocationStateNoChange();

class LocationController
    extends
        ValueNotifier<
          ({
            String? locationName,
            bool nameValid,
            double? latitude,
            double? longitude,
            bool mapEditMode,
            MapEntry<String, PhosphorIconData>? locationIcon,
            List<MapEntry<String, PhosphorIconData Function([PhosphorIconsStyle])>>? searchedIcons,
          })
        >
    implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseService firebase;
  final Location? passedLocation;

  LocationController({
    required this.logger,
    required this.hive,
    required this.firebase,
    required this.passedLocation,
  }) : super((
         locationName: null,
         nameValid: false,
         latitude: null,
         longitude: null,
         mapEditMode: false,
         locationIcon: null,
         searchedIcons: null,
       ));

  ///
  /// VARIABLES
  ///

  var mapReady = false;

  late final nameTextEditingController = TextEditingController(
    text: passedLocation?.name,
  );

  late final addressTextEditingController = TextEditingController(
    text: passedLocation?.address,
  );

  late final noteTextEditingController = TextEditingController(
    text: passedLocation?.note,
  );

  late final iconTextEditingController = TextEditingController(
    text: passedLocation?.iconName,
  );

  late final mapController = MapController();

  ///
  /// INIT
  ///

  Future<void> init({required String locale}) async {
    updateState(
      locationName: passedLocation?.name,
      nameValid: passedLocation?.name.isNotEmpty ?? false,
      latitude: passedLocation?.latitude,
      longitude: passedLocation?.longitude,
      mapEditMode: false,
      locationIcon: getPhosphorIconFromName(
        passedLocation?.iconName,
      ),
      searchedIcons: getPhosphorIconsFromName(
        iconTextEditingController.text.trim().toLowerCase(),
      ),
    );

    /// Validation
    nameTextEditingController.addListener(
      () {
        final name = nameTextEditingController.text.trim();

        updateState(
          locationName: name,
          nameValid: name.isNotEmpty,
        );
      },
    );

    /// Icon search
    iconTextEditingController.addListener(
      () => updateState(
        searchedIcons: getPhosphorIconsFromName(
          iconTextEditingController.text.trim(),
        ),
      ),
    );

    await setLocaleIdentifier(locale);
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    nameTextEditingController.dispose();
    addressTextEditingController.dispose();
    noteTextEditingController.dispose();
    iconTextEditingController.dispose();
    mapController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Triggered when the user presses an [Icon]
  void iconChanged(MapEntry<String, PhosphorIconData Function([PhosphorIconsStyle])> newIcon) => updateState(
    locationIcon: value.locationIcon?.key == newIcon.key ? null : newIcon,
  );

  /// Triggered when the user enables map edit mode
  void mapEditModeChanged() => updateState(mapEditMode: true);

  /// Triggered when the user moves the map
  void onMapEvent(MapEvent event) => updateState(
    latitude: event.camera.center.latitude,
    longitude: event.camera.center.longitude,
  );

  /// Triggered when the user submits the value in the `Address` [TextField]
  Future<void> onAddressSubmitted(String address) async {
    final trimmedAddress = address.trim();

    /// Empty address, update `state` to empty
    if (trimmedAddress.isEmpty) {
      updateState(
        latitude: null,
        longitude: null,
      );
      return;
    }

    try {
      /// Search for location using `trimmedAddress`
      final locations = await locationFromAddress(trimmedAddress);

      /// Location found
      if (locations.firstOrNull != null) {
        final coordinates = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );

        /// Update `state`
        updateState(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
        );

        /// Move map
        if (mapReady) {
          mapController.move(
            coordinates,
            mapController.camera.zoom,
          );
        }
      } else {
        logger.d('LocationController -> onAddressSubmitted() -> No location found');
      }
    } catch (e) {
      logger.e('LocationController -> onAddressSubmitted() -> $e');
    }
  }

  /// Triggered when the user adds location
  Future<void> addLocation() async {
    /// Get [TextField] values
    final name = nameTextEditingController.text.trim();
    final address = addressTextEditingController.text.trim();
    final note = noteTextEditingController.text.trim();

    /// Create [Location]
    final newLocation = Location(
      id: passedLocation?.id ?? const Uuid().v1(),
      name: name,
      address: address.isNotEmpty ? address : null,
      latitude: address.isNotEmpty ? value.latitude : null,
      longitude: address.isNotEmpty ? value.longitude : null,
      note: note.isNotEmpty ? note : null,
      createdAt: passedLocation?.createdAt ?? DateTime.now(),
      iconName: value.locationIcon?.key,
    );

    /// User modified location
    if (passedLocation != null) {
      await hive.updateLocation(
        newLocation: newLocation,
      );

      unawaited(
        firebase.updateLocation(
          newLocation: newLocation,
        ),
      );
    }
    /// User created new location
    else {
      await hive.writeLocation(
        newLocation: newLocation,
      );

      unawaited(
        firebase.writeLocation(
          newLocation: newLocation,
        ),
      );
    }
  }

  /// Triggered when the user deletes location
  Future<void> deleteLocation() async {
    if (passedLocation != null) {
      await hive.deleteLocation(
        location: passedLocation!,
      );

      unawaited(
        firebase.deleteLocation(
          location: passedLocation!,
        ),
      );
    }
  }

  /// Updates `state`
  void updateState({
    String? locationName,
    bool? nameValid,
    Object? latitude = locationStateNoChange,
    Object? longitude = locationStateNoChange,
    bool? mapEditMode,
    Object? locationIcon = locationStateNoChange,
    List<MapEntry<String, PhosphorIconData Function([PhosphorIconsStyle])>>? searchedIcons,
  }) => value = (
    locationName: locationName ?? value.locationName,
    nameValid: nameValid ?? value.nameValid,
    latitude: identical(latitude, locationStateNoChange) ? value.latitude : latitude as double?,
    longitude: identical(longitude, locationStateNoChange) ? value.longitude : longitude as double?,
    mapEditMode: mapEditMode ?? value.mapEditMode,
    locationIcon: identical(locationIcon, locationStateNoChange) ? value.locationIcon : locationIcon as MapEntry<String, PhosphorIconData>?,
    searchedIcons: searchedIcons ?? value.searchedIcons,
  );
}
