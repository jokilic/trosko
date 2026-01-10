import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/transaction/ai_transaction.dart';
import 'hive_service.dart';
import 'logger_service.dart';

class AIService extends ValueNotifier<({GenerativeModel? generativeModel, bool isGenerating})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseAI ai;

  AIService({
    required this.logger,
    required this.hive,
    required this.ai,
  }) : super((generativeModel: null, isGenerating: false));

  ///
  /// VARIABLES
  ///

  final systemInstruction = '''
Only thing you should generate is a `List<AITransaction>` in `JSON` format using `Dart` language.

```dart
class AITransaction {
  final String? name;
  final int? amountCents;
  final String? categoryId;
  final String? note;
  final DateTime? createdAt;
  final String? locationId;
}
```

You will get:
1. Text of user's recorded voice (should be about one or multiple expenses)
2. `List<Category>`
3. `List<Location>`
4. `DateTime.now().toIso8601String()`

It's up to you to understand what the user meant and try to fill out as much as possible data for each `AITransaction`.
Every `AITransaction` field is nullable and you can return `null` if you don't have enough information about it.

Text can be in English or Croatian.
Generate fields using the language user spoke.

Example of user's text:
"Yesterday around noon I bought a book for 20 euro"

Example of your response:
```dart
[
  {
    name: 'Book',
    amountCents: 2000,
    createdAt: '2026-01-15T12:00:00.000Z', // Relative to that `DateTime.now().toIso8601String()`
    locationId: null, // Try to find the location from the passed `List<Location>`, in this example user didn't specify anything proper
    categoryId: null, // Try to find the category from the passed `List<Category>`, in this example user didn't specify anything proper
    note: null, // Try to find additional details, in this example user didn't specify anything proper
  }
]
```
''';

  final exampleTransaction = AITransaction(
    id: const Uuid().v1(),
    name: 'name of transaction',
    amountCents: 500,
    createdAt: DateTime.now(),
    note: 'some note with additional details',
    categoryId: 'some_category_id',
    locationId: 'some_location_id',
  );

  ///
  /// INIT
  ///

  void init() {
    initializeGemini();
  }

  ///
  /// METHODS
  ///

  /// Initialize `Gemini` backend service
  void initializeGemini() {
    try {
      final model = ai.generativeModel(
        // model: 'gemini-2.5-flash',
        model: 'gemini-2.5-flash-lite',
        systemInstruction: Content.system(systemInstruction),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseJsonSchema: exampleTransaction.toMap(),
        ),
      );

      updateState(
        generativeModel: model,
      );
    } catch (e) {
      logger.e('AIService -> initializeGemini() -> $e');
    }
  }

  /// Triggers `AI` with `prompt` and all necessary data
  Future<({String? aiResult, String? error})> triggerAI({required String prompt}) async {
    if (value.generativeModel == null) {
      const error = 'AIService -> triggerAI() -> generativeModel == null';
      logger.e(error);
      return (aiResult: null, error: error);
    }

    try {
      updateState(
        isGenerating: true,
      );

      final response = await value.generativeModel!.generateContent(
        [
          /// Prompt
          Content.text(prompt),

          /// Categories
          Content.text(
            hive.getCategories().toString(),
          ),

          /// Locations
          Content.text(
            hive.getLocations().toString(),
          ),

          /// Current `DateTime`
          Content.text(
            DateTime.now().toIso8601String(),
          ),
        ],
      );

      updateState(
        isGenerating: false,
      );

      return (aiResult: response.text, error: null);
    } catch (e) {
      final error = 'AIService -> triggerAI() -> $e';

      logger.e(error);

      updateState(
        isGenerating: false,
      );

      return (aiResult: null, error: '$e');
    }
  }

  /// Updates state
  void updateState({
    GenerativeModel? generativeModel,
    bool? isGenerating,
  }) => value = (
    generativeModel: generativeModel ?? value.generativeModel,
    isGenerating: isGenerating ?? value.isGenerating,
  );
}
