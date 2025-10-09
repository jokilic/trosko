import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
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
import 'services/logger_service.dart';
import 'theme/theme.dart';
import 'util/dependencies.dart';
import 'util/display_mode.dart';
import 'util/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Make sure the orientation is only `portrait`
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /// Initialize [EasyLocalization]
  await EasyLocalization.ensureInitialized();

  /// Initialize [Firebase]
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Initialize dates
  await initializeDateFormatting('en');
  await initializeDateFormatting('hr');

  /// Initialize services
  initializeServices();

  /// Wait for initialization to finish
  await getIt.allReady();

  /// Use `edge-to-edge` display
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  /// Set refresh rate to high
  await setDisplayMode(
    logger: getIt.get<LoggerService>(),
  );

  /// Get `settings` value from [Hive]
  final settings = getIt.get<HiveService>().getSettings();

  /// Run `Troško`
  runApp(
    TroskoApp(
      isLoggedIn: settings.isLoggedIn && FirebaseAuth.instance.currentUser != null,
    ),
  );
}

class TroskoApp extends StatelessWidget {
  final bool isLoggedIn;

  const TroskoApp({
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) => EasyLocalization(
    useOnlyLangCode: true,
    supportedLocales: const [
      Locale('en'),
      Locale('hr'),
    ],
    fallbackLocale: const Locale('hr'),
    path: 'assets/translations',
    child: TroskoWidget(
      isLoggedIn: isLoggedIn,
    ),
  );
}

class TroskoWidget extends WatchingWidget {
  final bool isLoggedIn;

  const TroskoWidget({
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    final settings = watchIt<HiveService>().value.settings;

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? const HomeScreen(
              key: ValueKey('home'),
            )
          : const LoginScreen(
              key: ValueKey('login'),
            ),
      onGenerateTitle: (_) => 'appName'.tr(),
      theme: TroskoTheme.light(
        primaryColor: settings?.primaryColor,
      ),
      darkTheme: TroskoTheme.dark(
        primaryColor: settings?.primaryColor,
      ),
      themeMode: getThemeMode(
        themeModeInt: settings?.themeModeInt ?? 0,
      ),
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
}
