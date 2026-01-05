import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'logger_service.dart';

class SpeechToTextService extends ValueNotifier<({SpeechToText? speechToText, bool available, bool isListening, String? lastWords})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  SpeechToTextService({
    required this.logger,
  }) : super((speechToText: null, available: false, isListening: false, lastWords: null));

  ///
  /// INIT
  ///

  Future<void> init() async {
    await loadSpeechToText();
  }

  ///
  /// METHODS
  ///

  /// Loads speech to text used throughout the app
  Future<void> loadSpeechToText() async {
    /// Don't load if already loaded
    if (value.speechToText != null) {
      return;
    }

    try {
      final speechToText = SpeechToText();

      final available = await speechToText.initialize(
        debugLogging: kDebugMode,
        onStatus: (status) {
          log('SpeechToTextService -> status -> $status');
        },
        onError: (error) {
          log('SpeechToTextService -> error -> $error');
        },
      );

      updateState(
        speechToText: speechToText,
        available: available,
      );
    } catch (e) {
      logger.e('SpeechToTextService -> loadSpeechToText() -> $e');
    }
  }

  /// Starts a speech recognition session
  Future<void> startListening() async {
    if (value.speechToText == null) {
      logger.e('SpeechToTextService -> startListening() -> speechToText == null');
      return;
    }

    try {
      await value.speechToText!.listen(
        onResult: onSpeechResult,
      );
    } catch (e) {
      logger.e('SpeechToTextService -> startListening() -> $e');
    }
  }

  /// Manually stop the speech recognition session
  Future<void> stopListening() async {
    if (value.speechToText == null) {
      logger.e('SpeechToTextService -> stopListening() -> speechToText == null');
      return;
    }

    try {
      await value.speechToText!.stop();
    } catch (e) {
      logger.e('SpeechToTextService -> stopListening() -> $e');
    }
  }

  /// Callback which [SpeechToText] calls when the platform returns recognized words
  void onSpeechResult(SpeechRecognitionResult result) {
    try {
      updateState(
        lastWords: result.recognizedWords,
      );
    } catch (e) {
      logger.e('SpeechToTextService -> onSpeechResult() -> $e');
    }
  }

  /// Updates `state`
  void updateState({
    SpeechToText? speechToText,
    bool? available,
    bool? isListening,
    String? lastWords,
  }) => value = (
    speechToText: speechToText ?? value.speechToText,
    available: available ?? value.available,
    isListening: isListening ?? value.isListening,
    lastWords: lastWords ?? value.lastWords,
  );
}
