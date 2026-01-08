import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';

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
You will get a text of user's recorded voice.
User should be talking about one or multiple expenses.

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

You will get a `List<Category>` and `List<Location>` which can be a part of each `AITransaction`.
It's up to you to understand what the user meant and try to fill out as much as possible data for each `AITransaction`.
Every `AITransaction` field is nullable and you can return `null` if you don't have enough information about it.

You will also get `DateTime.now().toIso8601String()` to help you generate the `createdAt`, but return still `null` if the user didn't specify any date or time.

Keep in mind the text can be in English or Croatian.
Generate fields using the language user spoke.

Example:
"Yesterday around noon I bought a book for 20 euro"

```
name -> 'Book'
amountCents -> 2000
createdAt -> '2026-01-15T12:00:00.000Z' (relative to that `DateTime.now().toIso8601String()`)
locationId -> try to find the location from the passed `List<Location>`, in example user didn't specify anything proper
categoryId -> try to find the category from the passed `List<Category>`, in example user didn't specify anything proper
note -> try to find additional details, in example user didn't specify anything proper
```
''';

  final exampleTransaction = AITransaction(
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
        model: 'gemini-2.5-flash',
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

  Future<void> triggerAI({required String prompt}) async {
    if (value.generativeModel == null) {
      logger.e('AIService -> triggerAI() -> generativeModel == null');
      return;
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

      print('----------------------');
      print(response.text);
      print('----------------------');
    } catch (e) {
      logger.e('AIService -> triggerAI() -> $e');
    }

    updateState(
      isGenerating: false,
    );
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
