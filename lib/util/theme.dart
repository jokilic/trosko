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
  _ => null,
};

TroskoThemeId? getTroskoThemeId({required ThemeData? themeData}) => switch (themeData?.extension<TroskoThemeTag>()?.id) {
  TroskoThemeId.light => TroskoThemeId.light,
  TroskoThemeId.dark => TroskoThemeId.dark,
  _ => null,
};
