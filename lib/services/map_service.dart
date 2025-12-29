import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

import 'logger_service.dart';

class MapService extends ValueNotifier<Style?> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  MapService({
    required this.logger,
  }) : super(null);

  ///
  /// VARIABLES
  ///

  final openFreeMapBrightVectorUri = 'https://tiles.openfreemap.org/styles/bright';

  ///
  /// INIT
  ///

  Future<void> init() async {
    await loadVectorMapsStyle();
  }

  ///
  /// METHODS
  ///

  /// Loads style of vector maps used throughout the app
  Future<void> loadVectorMapsStyle() async {
    try {
      final style = await StyleReader(
        uri: openFreeMapBrightVectorUri,
        logger: const Logger.console(),
      ).read();

      value = style;
    } catch (e) {
      logger.e('MapsService -> loadVectorMapsStyle() -> $e');
    }
  }
}
