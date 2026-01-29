import 'package:flutter/material.dart';

import '../constants/durations.dart';

final troskoNavigatorKey = GlobalKey<NavigatorState>();

Future<T?> pushScreen<T>(
  Widget screen, {
  required BuildContext context,
  Duration? transitionDuration,
  Duration? reverseTransitionDuration,
}) => Navigator.of(context).push<T>(
  fadePageTransition(
    screen,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reverseTransitionDuration,
  ),
);

Future<T?> popAndPushScreen<T>(
  Widget screen, {
  required BuildContext context,
  Duration? transitionDuration,
  Duration? reverseTransitionDuration,
}) => Navigator.of(context).pushReplacement<T, T>(
  fadePageTransition(
    screen,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reverseTransitionDuration,
  ),
);

Future<T?> removeAllAndPushScreen<T>(
  Widget screen, {
  required BuildContext context,
  Duration? transitionDuration,
  Duration? reverseTransitionDuration,
}) => Navigator.of(context).pushAndRemoveUntil<T>(
  fadePageTransition(
    screen,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reverseTransitionDuration,
  ),
  (route) => false,
);

Route<T> fadePageTransition<T>(
  Widget screen, {
  Duration? transitionDuration,
  Duration? reverseTransitionDuration,
}) => PageRouteBuilder<T>(
  transitionDuration: transitionDuration ?? TroskoDurations.animation,
  reverseTransitionDuration: reverseTransitionDuration ?? TroskoDurations.animation,
  pageBuilder: (_, __, ___) => screen,
  transitionsBuilder: (_, animation, __, child) => FadeTransition(
    opacity: animation,
    child: child,
  ),
);
