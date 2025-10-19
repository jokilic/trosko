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

  Settings({
    required this.isLoggedIn,
    required this.troskoThemeId,
    required this.primaryColor,
  });

  Settings copyWith({
    bool? isLoggedIn,
    TroskoThemeId? troskoThemeId,
    Color? primaryColor,
    String? languageLocale,
  }) => Settings(
    isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    troskoThemeId: troskoThemeId ?? this.troskoThemeId,
    primaryColor: primaryColor ?? this.primaryColor,
  );

  @override
  String toString() => 'Settings(isLoggedIn: $isLoggedIn, troskoThemeId: $troskoThemeId, primaryColor: $primaryColor)';

  @override
  bool operator ==(covariant Settings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.isLoggedIn == isLoggedIn && other.troskoThemeId == troskoThemeId && other.primaryColor == primaryColor;
  }

  @override
  int get hashCode => isLoggedIn.hashCode ^ troskoThemeId.hashCode ^ primaryColor.hashCode;
}
