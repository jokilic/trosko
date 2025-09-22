import 'package:flutter/material.dart';

import 'logger_service.dart';

class ThemeService extends ValueNotifier<ThemeMode> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  ThemeService({
    required this.logger,
  }) : super(ThemeMode.system);

  ///
  /// METHODS
  ///

  void updateState() => value = value != ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;
}
