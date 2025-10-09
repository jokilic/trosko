import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import '../services/logger_service.dart';

Future<void> setDisplayMode({
  required LoggerService logger,
}) async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } on PlatformException catch (e) {
      logger.e('setDisplayMode() -> PlatformException -> $e');
    } catch (e) {
      logger.e('setDisplayMode() -> $e');
    }
  }
}
