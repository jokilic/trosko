import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

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

class VoiceScreen extends WatchingStatefulWidget {
  const VoiceScreen({
    required super.key,
  });

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<VoiceController>(
      () => VoiceController(
        logger: getIt.get<LoggerService>(),
        speechToText: getIt.get<SpeechToTextService>(),
      ),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<VoiceController>();
    super.dispose();
  }

  // TODO
  String getButtonText({
    required bool available,
    required bool isListening,
  }) {
    log('getButtonText() -> available: $available, isListening: $isListening');

    if (!available) {
      return 'Not available';
    }

    if (isListening) {
      return 'Listening...';
    }

    return 'Record';
  }

  @override
  Widget build(BuildContext context) {
    final voiceController = getIt.get<VoiceController>();

    final speechToTextState = watchIt<SpeechToTextService>().value;

    final available = speechToTextState.available;
    final isListening = speechToTextState.isListening;

    final useColorfulIcons = watchIt<HiveService>().value.settings?.useColorfulIcons ?? false;

    final state = watchIt<VoiceController>().value;

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
            // TODO
            smallTitle: 'Voice input',
            bigTitle: 'Voice input',
            bigSubtitle: 'Create expenses using voice',
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 4),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                // TODO
                state ?? '--',
                style: context.textStyles.homeTransactionNote,
              ),
            ),
          ),

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
            child: Text(
              getButtonText(
                available: available,
                isListening: isListening,
              ).toUpperCase(),
            ),
          ),
        ),
      ),
    );
  }
}
