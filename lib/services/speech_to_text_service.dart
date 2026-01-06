import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'logger_service.dart';

class SpeechToTextService extends ValueNotifier<({SpeechToText? speechToText, bool available, bool isListening})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  SpeechToTextService({
    required this.logger,
  }) : super((speechToText: null, available: false, isListening: false));

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
    try {
      final speechToText = value.speechToText ?? SpeechToText();

      final available = await speechToText.initialize(
        debugLogging: kDebugMode,
        onStatus: (status) {
          log('SpeechToTextService -> onStatus() -> $status');
        },
        onError: (error) {
          log('SpeechToTextService -> onError() -> $error');
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
  Future<void> startListening({
    required Function(SpeechRecognitionResult)? onResult,
    required String locale,
  }) async {
    if (value.speechToText == null) {
      logger.e('SpeechToTextService -> startListening() -> speechToText == null');
      return;
    }

    try {
      await value.speechToText!.listen(
        onResult: onResult,
        localeId: locale,
        listenOptions: SpeechListenOptions(
          // TODO
          sampleRate: 16000,
        ),
      );

      updateState(
        isListening: true,
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
      updateState(
        isListening: false,
      );

      unawaited(
        value.speechToText!.stop(),
      );
    } catch (e) {
      logger.e('SpeechToTextService -> stopListening() -> $e');
    }
  }

  /// Updates state
  void updateState({
    SpeechToText? speechToText,
    bool? available,
    bool? isListening,
  }) => value = (
    speechToText: speechToText ?? value.speechToText,
    available: available ?? value.available,
    isListening: isListening ?? value.isListening,
  );
}
