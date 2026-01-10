import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/transaction/ai_transaction.dart';
import '../../services/ai_service.dart';
import '../../services/logger_service.dart';
import '../../services/speech_to_text_service.dart';

/// Class to distinguish `no argument passed` from `explicitly passed null`
class VoiceStateNoChange {
  const VoiceStateNoChange();
}

const voiceStateNoChange = VoiceStateNoChange();

class VoiceController extends ValueNotifier<({String? userWords, List<AITransaction>? aiResults, String? aiError})> implements Disposable {
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
  }) : super((userWords: null, aiResults: null, aiError: null));

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
    updateState(
      aiResults: <AITransaction>[
        AITransaction(
          name: 'Hello there',
          note: 'Some note',
          amountCents: 100,
          createdAt: DateTime.now(),
        ),
      ],
    );
    return;

    /// [SpeechToText] was disabled, start listening
    if (!speechToText.value.isListening) {
      updateState(
        userWords: null,
        aiResults: null,
        aiError: null,
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

      /// Update `state` with potential `error`
      updateState(
        aiError: result.error,
      );

      /// AI generated result, parse it to ``List<AITransaction>``
      if (result.aiResult?.isNotEmpty ?? false) {
        final aiTransactions = parseAIResultToTransactions(
          aiResult: result.aiResult!,
        );

        /// Result is successfully parsed, add transactions to `state`
        if (aiTransactions != null) {
          /// Update `state` with parsed `transactions`
          updateState(
            aiResults: aiTransactions,
          );
        }
      }
    }
  }

  /// Parses AI result to `List<AITransaction>`
  List<AITransaction>? parseAIResultToTransactions({
    required String aiResult,
  }) {
    try {
      final decoded = jsonDecode(aiResult);

      if (decoded is List) {
        final parsedList = decoded
            .map(
              (item) => AITransaction.fromMap(
                item as Map<String, dynamic>,
              ),
            )
            .toList();

        return parsedList;
      }

      return <AITransaction>[];
    } catch (e) {
      logger.e('VoiceController -> parseAIResultToTransactions() -> $e');
      return null;
    }
  }

  /// Updates `state`
  void updateState({
    Object? userWords = voiceStateNoChange,
    Object? aiResults = voiceStateNoChange,
    Object? aiError = voiceStateNoChange,
  }) => value = (
    userWords: identical(userWords, voiceStateNoChange) ? value.userWords : userWords as String?,
    aiResults: identical(aiResults, voiceStateNoChange) ? value.aiResults : aiResults as List<AITransaction>?,
    aiError: identical(aiError, voiceStateNoChange) ? value.aiError : aiError as String?,
  );
}
