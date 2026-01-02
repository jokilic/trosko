import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

import 'logger_service.dart';

const openStreetMapVectorUri = 'https://tiles.openfreemap.org/styles/bright';
const openStreetMapUri = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

class MapService extends ValueNotifier<Style?> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  MapService({
    required this.logger,
  }) : super(null);

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
    /// Don't load if already loaded
    if (value != null) {
      return;
    }

    try {
      final style = await StyleReader(
        uri: openStreetMapVectorUri,
        logger: const Logger.console(),
      ).read();

      value = style;
    } catch (e) {
      logger.e('MapsService -> loadVectorMapsStyle() -> $e');
    }
  }
}
