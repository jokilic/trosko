import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:watch_it/watch_it.dart';

import 'constants/durations.dart';
import 'firebase_options.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'services/hive_service.dart';
import 'services/theme_service.dart';
import 'theme/theme.dart';
import 'util/dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Make sure the orientation is only `portrait`
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /// Initialize [Firebase]
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Initialize dates
  await initializeDateFormatting('hr');

  /// Initialize services
  initializeServices();

  /// Wait for initialization to finish
  await getIt.allReady();

  /// Get `isLoggedIn` value from [Hive] & [Firebase]
  final isLoggedIn = getIt.get<HiveService>().getIsLoggedIn() && FirebaseAuth.instance.currentUser != null;

  /// Run `Troško`
  runApp(
    TroskoApp(
      isLoggedIn: isLoggedIn,
    ),
  );
}

class TroskoApp extends WatchingWidget {
  final bool isLoggedIn;

  const TroskoApp({
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isLoggedIn
        ? const HomeScreen(
            key: ValueKey('home'),
          )
        : const LoginScreen(
            key: ValueKey('login'),
          ),
    onGenerateTitle: (context) => 'Troško',
    theme: TroskoTheme.light,
    darkTheme: TroskoTheme.dark,
    themeMode: watchIt<ThemeService>().value,
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
