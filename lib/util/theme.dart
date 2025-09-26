import 'package:flutter/material.dart';

ThemeMode getThemeMode({
  required int themeModeInt,
}) => switch (themeModeInt) {
  1 => ThemeMode.light,
  2 => ThemeMode.dark,
  _ => ThemeMode.system,
};

int getThemeModeInt({
  required ThemeMode themeMode,
}) => switch (themeMode) {
  ThemeMode.light => 1,
  ThemeMode.dark => 2,
  _ => 0,
};
