import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/ai_service.dart';
import '../../services/logger_service.dart';
import '../../services/speech_to_text_service.dart';

/// Class to distinguish `no argument passed` from `explicitly passed null`
class VoiceStateNoChange {
  const VoiceStateNoChange();
}

const voiceStateNoChange = VoiceStateNoChange();

class VoiceController extends ValueNotifier<({String? userWords, String? aiResult})> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final SpeechToTextService speechToText;
  final AIService ai;

  VoiceController({
    required this.logger,
    required this.speechToText,
    required this.ai,
  }) : super((userWords: null, aiResult: null));

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    speechToText.updateState(
      isListening: false,
    );
  }

  ///
  /// METHODS
  ///

  /// Triggered when the user presses [SpeechToText] button
  Future<void> onSpeechToTextPressed({
    required String locale,
  }) async {
    /// [SpeechToText] was disabled, start listening
    if (!speechToText.value.isListening) {
      updateState(
        userWords: null,
        aiResult: null,
      );

      await speechToText.startListening(
        onResult: (words) => updateState(
          userWords: words,
        ),
        locale: locale,
      );
    }
    /// [SpeechToText] was enabled, stop listening & trigger `AI`
    else {
      await speechToText.stopListening();

      await triggerAI();
    }
  }

  /// Triggers AI with `prompt` used from `state`
  Future<void> triggerAI() async {
    if (value.userWords?.isNotEmpty ?? false) {
      final result = await ai.triggerAI(
        prompt: value.userWords!,
      );

      /// Result from `AI` exists, update `state`
      if (result?.isNotEmpty ?? false) {
        updateState(
          aiResult: result,
        );
      }
    }
  }

  /// Updates `state`
  void updateState({
    Object? userWords = voiceStateNoChange,
    Object? aiResult = voiceStateNoChange,
  }) => value = (
    userWords: identical(userWords, voiceStateNoChange) ? value.userWords : userWords as String?,
    aiResult: identical(aiResult, voiceStateNoChange) ? value.aiResult : aiResult as String?,
  );
}
