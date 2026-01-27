import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/category/category.dart';
import '../../../theme/extensions.dart';
import '../../../util/icons.dart';
import '../../../util/search.dart';
import '../../../widgets/trosko_text_field.dart';
import 'transaction_category.dart';

class TransactionCategorySearchModal extends StatefulWidget {
  final List<Category> categories;
  final bool useColorfulIcons;

  const TransactionCategorySearchModal({
    required this.categories,
    required this.useColorfulIcons,
    required super.key,
  });

  @override
  State<TransactionCategorySearchModal> createState() => _TransactionCategorySearchModalState();
}

class _TransactionCategorySearchModalState extends State<TransactionCategorySearchModal> {
  late final textEditingController = TextEditingController();
  late var currentCategories = widget.categories;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(updateState);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void updateState() {
    /// Get `query`
    final searchText = textEditingController.text.trim();

    /// Search all `categories`
    final items = searchCategories(
      items: widget.categories,
      query: searchText,
    );

    /// Sort `categories`
    final sortedItems = items
      ..sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

    /// Update `state`
    setState(
      () => currentCategories = sortedItems,
    );
  }

  /// Searches `categories` using passed `query`
  List<Category> searchCategories({
    required List<Category> items,
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
            (c) => normalizeString(c.name).contains(nq),
          )
          .toList();
    }

    final scored = <({Category c, int score})>[];

    for (final c in items) {
      final fields = [
        c.name,
      ];

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
        scored.add((c: c, score: score));
      }
    }

    scored.sort((a, b) {
      final s = b.score.compareTo(a.score);
      return s != 0 ? s : a.c.name.compareTo(b.c.name);
    });

    return [for (final e in scored) e.c];
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          /// CATEGORIES
          ///
          IntrinsicHeight(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  currentCategories.length,
                  (index) {
                    final category = currentCategories[index];

                    final icon = getPhosphorIconFromName(category.iconName)?.value;

                    return TransactionCategory(
                      key: ValueKey(category.id),
                      onPressed: (category) {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop(category);
                      },
                      category: category,
                      color: category.color.withValues(
                        alpha: 0.2,
                      ),
                      highlightColor: category.color.withValues(
                        alpha: 0.2,
                      ),
                      icon: icon != null
                          ? getPhosphorIcon(
                              icon,
                              isDuotone: widget.useColorfulIcons,
                              isBold: false,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          ///
          /// TEXT
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              'transactionCategorySearchModalText'.tr(),
              style: context.textStyles.homeTitle,
            ),
          ),
          const SizedBox(height: 12),

          ///
          /// SEARCH
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TroskoTextField(
              autofocus: true,
              controller: textEditingController,
              labelText: 'searchTextField'.tr(),
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.search,
            ),
          ),
        ],
      ),
    ),
  );
}
