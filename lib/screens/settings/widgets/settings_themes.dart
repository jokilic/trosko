import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../models/trosko_theme_tag/trosko_theme_tag.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../theme/theme.dart';
import 'settings_theme.dart';

class SettingsThemes extends StatelessWidget {
  final TroskoThemeId? activeTroskoThemeId;
  final Function(ThemeData? themeData) onPressedThemeData;
  final Color primaryColor;

  const SettingsThemes({
    required this.activeTroskoThemeId,
    required this.onPressedThemeData,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(
      height: 88,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          ///
          /// SYSTEM
          ///
          SettingsSystemTheme(
            onPressed: () => onPressedThemeData(null),
            highlightColor: context.colors.buttonBackground,
            text: 'settingsSystem'.tr(),
            circleOpacity: activeTroskoThemeId == null ? 1 : 0.4,
          ),
          const SizedBox(width: 16),

          ///
          /// LIGHT
          ///
          SettingsTheme(
            onPressed: () => onPressedThemeData(
              TroskoTheme.light(primaryColor: primaryColor),
            ),
            color: TroskoColors.lightThemeWhiteScaffold,
            highlightColor: context.colors.buttonBackground,
            text: 'settingsLight'.tr(),
            circleOpacity: activeTroskoThemeId == TroskoThemeId.light ? 1 : 0.4,
          ),
          const SizedBox(width: 16),

          ///
          /// DARK
          ///
          SettingsTheme(
            onPressed: () => onPressedThemeData(
              TroskoTheme.dark(primaryColor: primaryColor),
            ),
            color: TroskoColors.darkThemeBlackScaffold,
            highlightColor: context.colors.buttonBackground,
            text: 'settingsDark'.tr(),
            circleOpacity: activeTroskoThemeId == TroskoThemeId.dark ? 1 : 0.4,
          ),
        ],
      ),
    ),
  );
}
