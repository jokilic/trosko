import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../services/ai_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../services/speech_to_text_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/color.dart';
import '../../util/dependencies.dart';
import '../../util/icons.dart';
import '../../widgets/trosko_app_bar.dart';
import 'voice_controller.dart';
import 'widgets/voice_list_tile.dart';

class VoiceScreen extends WatchingStatefulWidget {
  const VoiceScreen({
    required super.key,
  });

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  var showFullExplanationText = true;

  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<VoiceController>(
      () => VoiceController(
        logger: getIt.get<LoggerService>(),
        speechToText: getIt.get<SpeechToTextService>(),
        ai: getIt.get<AIService>(),
      ),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<VoiceController>();
    super.dispose();
  }

  String getButtonText({
    required bool available,
    required bool isListening,
    required bool isGenerating,
  }) {
    if (!available) {
      return 'voiceButtonNotAvailable'.tr();
    }

    if (isGenerating) {
      return 'voiceButtonThinking'.tr();
    }

    if (isListening) {
      return 'voiceButtonListening'.tr();
    }

    return 'voiceButtonStart'.tr();
  }

  String getLanguageName({
    required String languageCode,
  }) {
    switch (languageCode) {
      case 'en':
        return 'settingsEnglish'.tr();
      case 'hr':
        return 'settingsCroatian'.tr();
      default:
        return '--';
    }
  }

  @override
  Widget build(BuildContext context) {
    final voiceController = getIt.get<VoiceController>();

    final speechToTextState = watchIt<SpeechToTextService>().value;

    final available = speechToTextState.available;
    final isListening = speechToTextState.isListening;

    final isGenerating = watchIt<AIService>().value.isGenerating;

    final useColorfulIcons = watchIt<HiveService>().value.settings?.useColorfulIcons ?? false;

    final state = watchIt<VoiceController>().value;

    final userWords = state.userWords;
    final aiResult = state.aiResult;
    final aiError = state.aiError;

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          ///
          /// APP BAR
          ///
          TroskoAppBar(
            leadingWidget: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                highlightColor: context.colors.buttonBackground,
              ),
              icon: PhosphorIcon(
                getPhosphorIcon(
                  PhosphorIcons.arrowLeft,
                  isDuotone: useColorfulIcons,
                  isBold: true,
                ),
                color: context.colors.text,
                duotoneSecondaryColor: context.colors.buttonPrimary,
                size: 28,
              ),
            ),
            smallTitle: 'voiceTitle'.tr(),
            bigTitle: 'voiceTitle'.tr(),
            bigSubtitle: 'voiceSubtitle'.tr(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 4),
          ),

          ///
          /// YOU SAID
          ///
          if (isListening || (userWords?.isNotEmpty ?? false)) ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: VoiceListTile(
                  title: isListening ? 'voiceSayListening'.tr() : 'voiceSayYouSaid'.tr(),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
          ],

          ///
          /// SPOKEN TEXT
          ///
          if (isListening || (userWords?.isNotEmpty ?? false))
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverToBoxAdapter(
                child: Text(
                  userWords ?? '...',
                  style: context.textStyles.homeTransactionNote,
                ),
              ),
            )
          ///
          /// EXPLANATION TEXT
          ///
          else ...[
            ///
            /// TALK ABOUT EXPENSES
            ///
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: VoiceListTile(
                  title: 'voiceSayListening'.tr(),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'voiceText1'.tr(),
                  style: context.textStyles.homeTransactionNote,
                ),
              ),
            ),

            if (showFullExplanationText) ...[
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'voiceText2'.tr(),
                    style: context.textStyles.homeTransactionNote,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'voiceText3'.tr(),
                    style: context.textStyles.homeTransactionNote,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 28),
              ),

              ///
              /// CHECK NEW EXPENSES
              ///
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: VoiceListTile(
                    title: 'voiceCheckNewExpenses'.tr(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'voiceText4'.tr(),
                    style: context.textStyles.homeTransactionNote,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'voiceCheckNewExpensesText'.tr(),
                    style: context.textStyles.homeTransactionNote,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 28),
              ),

              ///
              /// SAVE NEW EXPENSES
              ///
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: VoiceListTile(
                    title: 'voiceSaveNewExpenses'.tr(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'voiceSaveNewExpensesText'.tr(),
                    style: context.textStyles.homeTransactionNote,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 28),
              ),

              ///
              /// ACTIVE LANGUAGE
              ///
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: VoiceListTile(
                    title: 'voiceLanguage'.tr(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                sliver: SliverToBoxAdapter(
                  child: Text.rich(
                    TextSpan(
                      text: getLanguageName(
                        languageCode: context.locale.languageCode,
                      ),
                      children: [
                        TextSpan(
                          text: 'voiceActiveLanguage'.tr(),
                          style: context.textStyles.homeTransactionNote,
                        ),
                      ],
                    ),
                    style: context.textStyles.homeTransactionNoteBold,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'voiceActiveLanguageChange'.tr(),
                    style: context.textStyles.homeTransactionNote,
                  ),
                ),
              ),
            ],
          ],

          ///
          /// GENERATED TEXT
          ///
          if (!isListening && !isGenerating && (aiResult?.isNotEmpty ?? false)) ...[
            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: VoiceListTile(
                  title: 'voiceResults'.tr(),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverToBoxAdapter(
                child: Text(
                  aiResult!,
                  style: context.textStyles.homeTransactionNote,
                ),
              ),
            ),
          ],

          ///
          /// ERROR TEXT
          ///
          if (!isListening && !isGenerating && (aiError?.isNotEmpty ?? false)) ...[
            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: VoiceListTile(
                  title: 'voiceError'.tr(),
                  backgroundColor: context.colors.delete.withValues(alpha: 0.2),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverToBoxAdapter(
                child: Text(
                  aiError!,
                  style: context.textStyles.homeTransactionNote,
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(
            child: SizedBox(height: 48),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: available
                ? () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );
                    await voiceController.onSpeechToTextPressed(
                      locale: context.locale.languageCode,
                    );
                    setState(
                      () => showFullExplanationText = false,
                    );
                  }
                : null,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.fromLTRB(
                24,
                28,
                24,
                MediaQuery.paddingOf(context).bottom + 12,
              ),
              backgroundColor: context.colors.buttonPrimary,
              foregroundColor: getWhiteOrBlackColor(
                backgroundColor: context.colors.buttonPrimary,
                whiteColor: TroskoColors.lightThemeWhiteBackground,
                blackColor: TroskoColors.lightThemeBlackText,
              ),
              overlayColor: context.colors.buttonBackground,
              disabledBackgroundColor: context.colors.disabledBackground,
              disabledForegroundColor: context.colors.disabledText,
            ),
            child: Animate(
              key: ValueKey('$isListening-$isGenerating'),
              onPlay: (controller) => controller.loop(
                reverse: true,
                min: 0.6,
              ),
              effects: [
                if (isListening || isGenerating)
                  const FadeEffect(
                    curve: Curves.easeIn,
                    duration: TroskoDurations.recording,
                  ),
              ],
              child: Text(
                getButtonText(
                  available: available,
                  isListening: isListening,
                  isGenerating: isGenerating,
                ).toUpperCase(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
