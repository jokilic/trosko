import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

@HiveType(typeId: 14)
enum TroskoThemeId {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
  @HiveField(2)
  blue,
}

class TroskoThemeTag extends ThemeExtension<TroskoThemeTag> {
  final TroskoThemeId id;

  const TroskoThemeTag(this.id);

  @override
  TroskoThemeTag copyWith({
    TroskoThemeId? id,
  }) => TroskoThemeTag(id ?? this.id);

  @override
  TroskoThemeTag lerp(
    ThemeExtension<TroskoThemeTag>? other,
    double t,
  ) => this;
}
