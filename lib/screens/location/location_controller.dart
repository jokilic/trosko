import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/category/category.dart';
import '../../models/location/location.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class LocationController
    extends
        ValueNotifier<
          ({String? categoryName, Color? categoryColor, bool nameValid, MapEntry<String, PhosphorIconData>? categoryIcon, List<MapEntry<String, PhosphorIconData>>? searchedIcons})
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
         categoryName: null,
         categoryColor: null,
         nameValid: false,
         categoryIcon: null,
         searchedIcons: null,
       ));

  ///
  /// VARIABLES
  ///

  late final nameTextEditingController = TextEditingController(
    text: passedLocation?.name,
  );

  // late final iconTextEditingController = TextEditingController(
  //   text: passedLocation?.iconName,
  // );

  ///
  /// INIT
  ///

  // void init() {
  //   updateState(
  //     categoryName: passedLocation?.name,
  //     categoryColor: passedLocation?.color,
  //     nameValid: passedLocation?.name.isNotEmpty ?? false,
  //     categoryIcon: getRegularIconFromName(
  //       passedLocation?.iconName,
  //     ),
  //     searchedIcons: getRegularIconsFromName(
  //       iconTextEditingController.text.trim().toLowerCase(),
  //     ),
  //   );

  //   /// Validation
  //   nameTextEditingController.addListener(
  //     () {
  //       final name = nameTextEditingController.text.trim();

  //       updateState(
  //         categoryName: name,
  //         nameValid: name.isNotEmpty,
  //       );
  //     },
  //   );

  //   /// Icon search
  //   iconTextEditingController.addListener(
  //     () => updateState(
  //       searchedIcons: getRegularIconsFromName(
  //         iconTextEditingController.text.trim(),
  //       ),
  //     ),
  //   );
  // }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    nameTextEditingController.dispose();
    // iconTextEditingController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Triggered when the user presses a [Color]
  void colorChanged(Color newColor) => updateState(
    categoryColor: newColor,
  );

  /// Triggered when the user presses an [Icon]
  void iconChanged(MapEntry<String, PhosphorIconData> newIcon) => updateState(
    categoryIcon: newIcon,
  );

  /// Triggered when the user adds category
  Future<void> addCategory() async {
    /// Get [TextField] values
    final name = nameTextEditingController.text.trim();

    /// Create [Category]
    final newCategory = Category(
      id: passedLocation?.id ?? const Uuid().v1(),
      name: name,
      iconName: value.categoryIcon!.key,
      color: value.categoryColor!,
      createdAt: passedLocation?.createdAt ?? DateTime.now(),
    );

    /// User modified category
    if (passedLocation != null) {
      await hive.updateCategory(
        newCategory: newCategory,
      );

      unawaited(
        firebase.updateCategory(
          newCategory: newCategory,
        ),
      );
    }
    /// User created new category
    else {
      await hive.writeCategory(
        newCategory: newCategory,
      );

      unawaited(
        firebase.writeCategory(
          newCategory: newCategory,
        ),
      );
    }
  }

  /// Triggered when the user deletes category
  // Future<void> deleteCategory() async {
  //   if (passedLocation != null) {
  //     await hive.deleteCategory(
  //       category: passedLocation!,
  //     );

  //     unawaited(
  //       firebase.deleteCategory(
  //         category: passedLocation!,
  //       ),
  //     );
  //   }
  // }

  /// Updates `state`
  void updateState({
    String? categoryName,
    Color? categoryColor,
    bool? nameValid,
    MapEntry<String, PhosphorIconData>? categoryIcon,
    List<MapEntry<String, PhosphorIconData>>? searchedIcons,
  }) => value = (
    categoryName: categoryName ?? value.categoryName,
    categoryColor: categoryColor ?? value.categoryColor,
    nameValid: nameValid ?? value.nameValid,
    categoryIcon: categoryIcon ?? value.categoryIcon,
    searchedIcons: searchedIcons ?? value.searchedIcons,
  );
}
