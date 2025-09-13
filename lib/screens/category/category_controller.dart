import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../models/category/category.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class CategoryController extends ValueNotifier<({Color? categoryColor, bool nameValid})> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final Category? passedCategory;

  CategoryController({
    required this.logger,
    required this.hive,
    required this.passedCategory,
  }) : super((
         categoryColor: null,
         nameValid: false,
       ));

  ///
  /// VARIABLES
  ///

  late final nameTextEditingController = TextEditingController(
    text: passedCategory?.name,
  );

  ///
  /// INIT
  ///

  void init() {
    updateState(
      categoryColor: passedCategory?.color,
      nameValid: passedCategory?.name.isNotEmpty ?? false,
    );

    /// Validation
    nameTextEditingController.addListener(
      () => updateState(
        nameValid: nameTextEditingController.text.trim().isNotEmpty,
      ),
    );
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    nameTextEditingController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Triggered when the user presses a [Color]
  void colorChanged(Color newColor) => updateState(
    categoryColor: newColor,
  );

  /// Triggered when the user adds category
  Future<void> addCategory() async {
    /// Get [TextField] values
    final name = nameTextEditingController.text.trim();

    /// Create [Category]
    final newCategory = Category(
      id: passedCategory?.id ?? const Uuid().v1(),
      name: name,
      color: value.categoryColor!,
    );

    /// User modified category
    if (passedCategory != null) {
      await hive.updateCategory(
        newCategory: newCategory,
      );
    }
    /// User created new category
    else {
      await hive.writeCategory(
        newCategory: newCategory,
      );
    }
  }

  /// Triggered when the user deletes category
  Future<void> deleteCategory() async {
    if (passedCategory != null) {
      await hive.deleteCategory(
        category: passedCategory!,
      );
    }
  }

  /// Updates `state`
  void updateState({
    Color? categoryColor,
    bool? nameValid,
  }) => value = (
    categoryColor: categoryColor ?? value.categoryColor,
    nameValid: nameValid ?? value.nameValid,
  );
}
