import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../../services/logger_service.dart';
import '../../services/speech_to_text_service.dart';

class VoiceController extends ValueNotifier<String?> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final SpeechToTextService speechToText;

  VoiceController({
    required this.logger,
    required this.speechToText,
  }) : super(null);

  ///
  /// METHODS
  ///

  /// Triggered when the user presses [SpeechToText] button
  Future<void> onSpeechToTextPressed({
    required String locale,
  }) async {
    /// [SpeechToText] was enabled, stop listening
    if (speechToText.value.isListening) {
      await speechToText.stopListening();

      /// Words exist, trigger AI
      if (value?.isNotEmpty ?? false) {
        // TODO
      }
    }
    /// [SpeechToText] was disabled, start listening
    else {
      await speechToText.startListening(
        onResult: onSpeechResult,
        locale: locale,
      );
    }
  }

  /// Callback which [SpeechToText] calls when the platform returns recognized words
  void onSpeechResult(SpeechRecognitionResult result) {
    try {
      value = result.recognizedWords;

      log('VoiceController -> onSpeechResult() -> ${result.recognizedWords}');
    } catch (e) {
      logger.e('VoiceController -> onSpeechResult() -> $e');
    }
  }
}
