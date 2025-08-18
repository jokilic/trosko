import 'package:flutter/material.dart';

import '../constants/durations.dart';

Future<T?> pushScreen<T>(
  Widget screen, {
  required BuildContext context,
  bool isCircularTransition = false,
  Duration? transitionDuration,
  Duration? reverseTransitionDuration,
}) => Navigator.of(context).push<T>(
  fadePageTransition(
    screen,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reverseTransitionDuration,
  ),
);

Route<T> fadePageTransition<T>(
  Widget screen, {
  Duration? transitionDuration,
  Duration? reverseTransitionDuration,
}) => PageRouteBuilder<T>(
  transitionDuration: transitionDuration ?? TroskoDurations.fadeAnimation,
  reverseTransitionDuration: reverseTransitionDuration ?? TroskoDurations.fadeAnimation,
  pageBuilder: (_, __, ___) => screen,
  transitionsBuilder: (_, animation, __, child) => FadeTransition(
    opacity: animation,
    child: child,
  ),
);
