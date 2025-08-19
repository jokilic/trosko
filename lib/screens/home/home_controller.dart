import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

class HomeController {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  HomeController({
    required this.logger,
    required this.hive,
  });
}
