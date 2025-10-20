import 'package:flutter/material.dart';

import '../../../theme/extensions.dart';
import 'settings_primary_color.dart';

class SettingsPrimaryColors extends StatelessWidget {
  final List<Color> primaryColors;
  final Color? activePrimaryColor;
  final Function(Color primaryColor) onPressedPrimaryColor;
  final GlobalKey Function(
    Color primaryColor,
    GlobalKey Function() key,
  )
  onGenerateKey;

  const SettingsPrimaryColors({
    required this.primaryColors,
    required this.activePrimaryColor,
    required this.onPressedPrimaryColor,
    required this.onGenerateKey,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(
      height: 88,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: primaryColors.length,
        itemBuilder: (_, index) {
          final color = primaryColors[index];
          final key = onGenerateKey(
            color,
            GlobalKey.new,
          );

          return SettingsPrimaryColor(
            key: key,
            onPressed: () => onPressedPrimaryColor(color),
            color: color,
            highlightColor: context.colors.buttonBackground,
            circleOpacity: activePrimaryColor == color ? 1 : 0.4,
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 16),
      ),
    ),
  );
}
