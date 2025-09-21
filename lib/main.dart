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

  /// Run `Troško`
  runApp(TroskoApp());
}

class TroskoApp extends WatchingWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        ///
        /// LOADING
        ///
        if (snapshot.connectionState == ConnectionState.waiting) {
          // TODO: Loading screen
          return Container();
        }

        ///
        /// USER LOGGED IN
        ///
        if (snapshot.hasData) {
          return const HomeScreen(
            key: ValueKey('home'),
          );
        }

        ///
        /// NO USER
        ///
        return const LoginScreen(
          key: ValueKey('login'),
        );
      },
    ),
    onGenerateTitle: (context) => 'Troško',
    theme: TroskoTheme.light,
    darkTheme: TroskoTheme.dark,
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
