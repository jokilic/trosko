import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../trosko_theme_tag/trosko_theme_tag.dart';

@HiveType(typeId: 13)
class Settings {
  @HiveField(1)
  final bool isLoggedIn;

  @HiveField(2)
  final TroskoThemeId? troskoThemeId;

  @HiveField(3)
  final Color? primaryColor;

  @HiveField(4)
  final bool? useNotificationListener;

  Settings({
    required this.isLoggedIn,
    required this.troskoThemeId,
    required this.primaryColor,
    required this.useNotificationListener,
  });

  Settings copyWith({
    Object? isLoggedIn = noChange,
    Object? troskoThemeId = noChange,
    Object? primaryColor = noChange,
    Object? useNotificationListener = noChange,
  }) => Settings(
    isLoggedIn: isLoggedIn == noChange ? this.isLoggedIn : isLoggedIn! as bool,
    troskoThemeId: troskoThemeId == noChange ? this.troskoThemeId : troskoThemeId as TroskoThemeId?,
    primaryColor: primaryColor == noChange ? this.primaryColor : primaryColor as Color?,
    useNotificationListener: useNotificationListener == noChange ? this.useNotificationListener : useNotificationListener as bool?,
  );

  static const noChange = Object();

  @override
  String toString() => 'Settings(isLoggedIn: $isLoggedIn, troskoThemeId: $troskoThemeId, primaryColor: $primaryColor, useNotificationListener: $useNotificationListener)';

  @override
  bool operator ==(covariant Settings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.isLoggedIn == isLoggedIn && other.troskoThemeId == troskoThemeId && other.primaryColor == primaryColor && other.useNotificationListener == useNotificationListener;
  }

  @override
  int get hashCode => isLoggedIn.hashCode ^ troskoThemeId.hashCode ^ primaryColor.hashCode ^ useNotificationListener.hashCode;
}
