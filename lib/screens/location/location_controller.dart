import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get_it/get_it.dart';
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

  ///
  /// INIT
  ///

  void init() {
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
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    nameTextEditingController.dispose();
    addressTextEditingController.dispose();
    noteTextEditingController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Triggered when the user submits the value in the `Address` [TextField]
  Future<void> onAddressSubmitted(String address) async {
    final trimmedAddress = address.trim();

    if (trimmedAddress.isEmpty) {
      return;
    }

    try {
      /// Search for location using `trimmedAddress`
      final locations = await locationFromAddress(trimmedAddress);

      /// Location found, update `state`
      if (locations.firstOrNull != null) {
        updateState(
          latitude: locations.first.latitude,
          longitude: locations.first.longitude,
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
      latitude: value.latitude!,
      longitude: value.longitude!,
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
