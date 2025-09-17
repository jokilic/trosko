import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'constants/durations.dart';
import 'screens/home/home_screen.dart';
import 'theme/theme.dart';
import 'util/dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Make sure the orientation is only `portrait`
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /// Initialize dates
  await initializeDateFormatting('hr');

  /// Initialize services
  initializeServices();

  /// Wait for initialization to finish
  await getIt.allReady();

  /// Run `Troško`
  runApp(TroskoApp());
}

class TroskoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomeScreen(
      key: ValueKey('home'),
    ),
    theme: TroskoTheme.light,
    darkTheme: TroskoTheme.dark,
    themeMode: ThemeMode.light,
    themeAnimationDuration: TroskoDurations.animation,
    themeAnimationCurve: Curves.easeIn,
    builder: (_, child) {
      final appWidget =
          child ??
          const Scaffold(
            body: SizedBox.shrink(),
          );

      return kDebugMode
          ? Banner(
              message: '',
              color: context.colors.buttonPrimary,
              location: BannerLocation.topEnd,
              layoutDirection: TextDirection.ltr,
              child: appWidget,
            )
          : appWidget;
    },
  );
}
