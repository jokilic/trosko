import 'package:flutter/material.dart';

import '../models/trosko_theme_tag/trosko_theme_tag.dart';
import '../theme/theme.dart';

ThemeData? getTroskoTheme({
  required TroskoThemeId? id,
  required Color primaryColor,
}) => switch (id) {
  TroskoThemeId.light => TroskoTheme.light(
    primaryColor: primaryColor,
  ),
  TroskoThemeId.dark => TroskoTheme.dark(
    primaryColor: primaryColor,
  ),
  TroskoThemeId.light2 => TroskoTheme.light2(
    primaryColor: primaryColor,
  ),
  TroskoThemeId.dark2 => TroskoTheme.dark2(
    primaryColor: primaryColor,
  ),
  _ => null,
};
