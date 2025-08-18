import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home/home_screen.dart';
import 'theme/theme.dart';
import 'util/dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Make sure the orientation is only `portrait`
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /// Initialize services
  initializeServices();

  /// Wait for initialization to finish
  await getIt.allReady();

  runApp(TroskoApp());
}

class TroskoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
    theme: TroskoTheme.light,
    builder: (_, child) {
      final appWidget =
          child ??
          const Scaffold(
            body: SizedBox.shrink(),
          );

      return kDebugMode
          ? Banner(
              message: '',
              color: Colors.indigo,
              location: BannerLocation.topEnd,
              layoutDirection: TextDirection.ltr,
              child: appWidget,
            )
          : appWidget;
    },
  );
}
