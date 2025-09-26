import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import 'settings_theme.dart';

class SettingsThemes extends StatelessWidget {
  final List<ThemeMode> themeModes;
  final ThemeMode? activeThemeMode;
  final Function(ThemeMode themeMode) onPressedThemeMode;

  const SettingsThemes({
    required this.themeModes,
    required this.activeThemeMode,
    required this.onPressedThemeMode,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(
      height: 72,
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
            iconColor: TroskoColors.lighterGrey,
            highlightColor: context.colors.buttonBackground,
            icon: activeThemeMode == ThemeMode.system
                ? PhosphorIcons.check(
                    PhosphorIconsStyle.bold,
                  )
                : null,
          ),
          const SizedBox(width: 16),

          ///
          /// LIGHT
          ///
          SettingsTheme(
            onPressed: () => onPressedThemeMode(
              ThemeMode.light,
            ),
            color: TroskoTheme.light.scaffoldBackgroundColor,
            highlightColor: context.colors.buttonBackground,
            icon: activeThemeMode == ThemeMode.light
                ? PhosphorIcons.check(
                    PhosphorIconsStyle.bold,
                  )
                : null,
          ),
          const SizedBox(width: 16),

          ///
          /// DARK
          ///
          SettingsTheme(
            onPressed: () => onPressedThemeMode(
              ThemeMode.dark,
            ),
            color: TroskoTheme.dark.scaffoldBackgroundColor,
            highlightColor: context.colors.buttonBackground,
            icon: activeThemeMode == ThemeMode.dark
                ? PhosphorIcons.check(
                    PhosphorIconsStyle.bold,
                  )
                : null,
          ),
          const SizedBox(width: 4),
        ],
      ),
    ),
  );
}
