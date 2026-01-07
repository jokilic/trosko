import 'package:flutter/foundation.dart';
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
          switch (status.toLowerCase().trim()) {
            /// Speech recognition begins
            case 'listening':
              updateState(
                isListening: true,
              );
              break;

            /// Speech recognition is no longer listening
            case 'notListening':
            case 'done':
              updateState(
                isListening: false,
              );
              break;
          }
        },
        onError: (error) {
          updateState(
            isListening: false,
          );
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
    required Function(String words) onResult,
    required String locale,
  }) async {
    if (value.speechToText == null) {
      logger.e('SpeechToTextService -> startListening() -> speechToText == null');
      return;
    }

    try {
      await value.speechToText!.listen(
        onResult: (result) => onResult(
          result.recognizedWords,
        ),
        localeId: locale,
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
      await value.speechToText!.stop();

      updateState(
        isListening: false,
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
