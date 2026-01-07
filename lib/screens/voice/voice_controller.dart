import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/logger_service.dart';
import '../../services/speech_to_text_service.dart';

class VoiceController extends ValueNotifier<String?> implements Disposable {
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
      value = null;

      await speechToText.startListening(
        onResult: (words) => value = words,
        locale: locale,
      );
    }
    /// [SpeechToText] was enabled, stop listening
    else {
      await speechToText.stopListening();

      /// Words exist, trigger AI
      if (value?.isNotEmpty ?? false) {
        // TODO
      }
    }
  }
}
