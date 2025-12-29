import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../../models/location/location.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class LocationController extends ValueNotifier<({String? locationName, bool nameValid, double? latitude, double? longitude})> implements Disposable {
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
       ));

  ///
  /// VARIABLES
  ///

  late final nameTextEditingController = TextEditingController(
    text: passedLocation?.name,
  );

  late final addressTextEditingController = TextEditingController(
    text: passedLocation?.address,
  );

  late final noteTextEditingController = TextEditingController(
    text: passedLocation?.note,
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
    mapController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Triggered when the user moves the map
  void onMapEvent(MapEvent event) => updateState(
    latitude: event.camera.center.latitude,
    longitude: event.camera.center.longitude,
  );

  /// Triggered when the user submits the value in the `Address` [TextField]
  Future<void> onAddressSubmitted(String address) async {
    final trimmedAddress = address.trim();

    if (trimmedAddress.isEmpty) {
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
        mapController.move(
          coordinates,
          mapController.camera.zoom,
        );
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
      address: address,
      latitude: address.isNotEmpty ? value.latitude : null,
      longitude: address.isNotEmpty ? value.longitude : null,
      note: note,
      createdAt: passedLocation?.createdAt ?? DateTime.now(),
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
    double? latitude,
    double? longitude,
  }) => value = (
    locationName: locationName ?? value.locationName,
    nameValid: nameValid ?? value.nameValid,
    latitude: latitude ?? value.latitude,
    longitude: longitude ?? value.longitude,
  );
}
