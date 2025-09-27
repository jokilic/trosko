import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import 'settings_theme.dart';

class SettingsThemes extends StatelessWidget {
  final ThemeMode? activeThemeMode;
  final Function(ThemeMode themeMode) onPressedThemeMode;

  const SettingsThemes({
    required this.activeThemeMode,
    required this.onPressedThemeMode,
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
            onPressed: () => onPressedThemeMode(
              ThemeMode.system,
            ),
            highlightColor: context.colors.buttonBackground,
            icon: activeThemeMode == ThemeMode.system
                ? PhosphorIcons.check(
                    PhosphorIconsStyle.bold,
                  )
                : null,
            text: 'System',
            circleOpacity: activeThemeMode == ThemeMode.system ? 1 : 0.4,
          ),
          const SizedBox(width: 16),

          ///
          /// LIGHT
          ///
          SettingsTheme(
            onPressed: () => onPressedThemeMode(
              ThemeMode.light,
            ),
            color: TroskoColors.lightGrey,
            highlightColor: context.colors.buttonBackground,
            icon: activeThemeMode == ThemeMode.light
                ? PhosphorIcons.check(
                    PhosphorIconsStyle.bold,
                  )
                : null,
            text: 'Light',
            circleOpacity: activeThemeMode == ThemeMode.light ? 1 : 0.4,
          ),
          const SizedBox(width: 16),

          ///
          /// DARK
          ///
          SettingsTheme(
            onPressed: () => onPressedThemeMode(
              ThemeMode.dark,
            ),
            color: TroskoColors.dark,
            highlightColor: context.colors.buttonBackground,
            icon: activeThemeMode == ThemeMode.dark
                ? PhosphorIcons.check(
                    PhosphorIconsStyle.bold,
                  )
                : null,
            text: 'Dark',
            circleOpacity: activeThemeMode == ThemeMode.dark ? 1 : 0.4,
          ),
        ],
      ),
    ),
  );
}
