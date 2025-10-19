import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/transaction/transaction.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../util/group_transactions.dart';
import '../../util/search.dart';

class SearchController extends ValueNotifier<({List<dynamic> datesAndTransactions, bool isTextFieldEmpty})> implements Disposable {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;
  final FirebaseService firebase;
  final String locale;

  SearchController({
    required this.logger,
    required this.hive,
    required this.firebase,
    required this.locale,
  }) : super((
         datesAndTransactions: [],
         isTextFieldEmpty: true,
       ));

  ///
  /// VARIABLES
  ///

  late final searchTextEditingController = TextEditingController();

  ///
  /// INIT
  ///

  void init() {
    searchTextEditingController.addListener(
      () => updateState(
        locale: locale,
      ),
    );
  }

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    searchTextEditingController.dispose();
  }

  ///
  /// METHODS
  ///

  /// Updates `state`, depending on passed [List<Transaction>]
  void updateState({
    required String locale,
  }) {
    /// Get `query`
    final searchText = searchTextEditingController.text.trim();

    /// Get all `transactions`
    final all = hive.getTransactions();

    /// Search all `transactions`
    final items = searchTransactions(
      items: all,
      query: searchText,
    );

    /// Sort `transactions`
    final sortedItems = items
      ..sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

    /// Update `state`
    value = (
      datesAndTransactions: searchText.isEmpty
          ? []
          : getGroupedTransactionsByDate(
              sortedItems,
              locale: locale,
            ),
      isTextFieldEmpty: searchText.isEmpty,
    );
  }

  /// Searches transactions using passed `query`
  List<Transaction> searchTransactions({
    required List<Transaction> items,
    required String query,
    // Higher to be stricter, lower to be fuzzier
    int threshold = 80,
  }) {
    final q = query.trim();
    if (q.isEmpty) {
      return items;
    }

    /// Short queries: only literal contains to avoid noise
    if (q.length <= 3) {
      final nq = normalizeString(q);

      return items
          .where(
            (t) => normalizeString(t.name).contains(nq) || (t.note != null && normalizeString(t.note!).contains(nq)),
          )
          .toList();
    }

    final scored = <({Transaction t, int score})>[];

    for (final t in items) {
      final fields = [t.name, if ((t.note ?? '').isNotEmpty) t.note!];

      /// Require trigram overlap with at least one field unless literal contains
      final passesGuard = fields.any((f) {
        final nf = normalizeString(f);
        return nf.contains(normalizeString(q)) || sharesTrigram(q, f);
      });

      if (!passesGuard) {
        continue;
      }

      final score = fields
          .map((f) => getFuzzyScore(q, f))
          .fold<int>(
            0,
            (mx, v) => v > mx ? v : mx,
          );

      if (score >= threshold) {
        scored.add((t: t, score: score));
      }
    }

    scored.sort((a, b) {
      final s = b.score.compareTo(a.score);
      return s != 0 ? s : a.t.name.compareTo(b.t.name);
    });

    return [for (final e in scored) e.t];
  }

  /// Triggered when the user deletes transaction
  Future<void> deleteTransaction({
    required Transaction transaction,
    required String locale,
  }) async {
    await hive.deleteTransaction(
      transaction: transaction,
    );

    unawaited(
      firebase.deleteTransaction(
        transaction: transaction,
      ),
    );

    updateState(
      locale: locale,
    );
  }
}
