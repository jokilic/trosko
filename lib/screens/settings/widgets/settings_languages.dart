import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/icons.dart';
import '../../../theme/theme.dart';
import 'settings_language.dart';

class SettingsLanguages extends StatelessWidget {
  final String? activeLanguageCode;
  final Function(String languageCode) onPressedLanguageCode;

  const SettingsLanguages({
    required this.activeLanguageCode,
    required this.onPressedLanguageCode,
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
          /// CROATIA
          ///
          SettingsLanguage(
            onPressed: () => onPressedLanguageCode('hr'),
            highlightColor: context.colors.buttonBackground,
            icon: TroskoIcons.croatia,
            activeIcon: context.locale.languageCode == 'hr'
                ? PhosphorIcons.check(
                    PhosphorIconsStyle.bold,
                  )
                : null,
          ),
          const SizedBox(width: 16),

          ///
          /// UNITED KINGDOM
          ///
          SettingsLanguage(
            onPressed: () => onPressedLanguageCode('en'),
            highlightColor: context.colors.buttonBackground,
            icon: TroskoIcons.unitedKingdom,
            activeIcon: context.locale.languageCode == 'en'
                ? PhosphorIcons.check(
                    PhosphorIconsStyle.bold,
                  )
                : null,
          ),
        ],
      ),
    ),
  );
}
