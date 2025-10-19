import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/icons.dart';
import '../../../theme/extensions.dart';
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
      height: 88,
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
            flagIcon: TroskoIcons.croatia,
            text: 'settingsCroatian'.tr(),
            circleOpacity: context.locale.languageCode == 'hr' ? 1 : 0.4,
          ),
          const SizedBox(width: 16),

          ///
          /// UNITED KINGDOM
          ///
          SettingsLanguage(
            onPressed: () => onPressedLanguageCode('en'),
            highlightColor: context.colors.buttonBackground,
            flagIcon: TroskoIcons.unitedKingdom,
            text: 'settingsEnglish'.tr(),
            circleOpacity: context.locale.languageCode == 'en' ? 1 : 0.4,
          ),
        ],
      ),
    ),
  );
}
