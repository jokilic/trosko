import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../models/category/category.dart';
import '../../models/month/month.dart';
import '../../models/transaction/transaction.dart';
import '../../theme/theme.dart';
import '../../util/stats.dart';
import '../../widgets/trosko_app_bar.dart';
import 'widgets/stats_all_list_tile.dart';
import 'widgets/stats_category_list_tile.dart';

class StatsScreen extends StatelessWidget {
  final Month month;
  final List<Transaction> transactions;
  final List<Category> categories;

  const StatsScreen({
    required this.month,
    required this.transactions,
    required this.categories,
    required super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      slivers: [
        ///
        /// APP BAR
        ///
        TroskoAppBar(
          leadingWidget: IconButton(
            onPressed: Navigator.of(context).pop,
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              highlightColor: context.colors.buttonBackground,
            ),
            icon: PhosphorIcon(
              PhosphorIcons.arrowLeft(
                PhosphorIconsStyle.bold,
              ),
              color: context.colors.text,
              size: 28,
            ),
          ),
          smallTitle: 'statsTitle'.tr(
            args: [month.label],
          ),
          bigTitle: 'statsTitle'.tr(
            args: [month.label],
          ),
          bigSubtitle: 'statsSubtitle'.tr(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 8),
        ),

        ///
        /// ALL
        ///
        SliverToBoxAdapter(
          child: StatsAllListTile(
            numberOfTransactions: transactions.length,
            amountCents: transactions.fold<int>(0, (s, t) => s + t.amountCents),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),

        ///
        /// CATEGORIES
        ///
        SliverList.builder(
          itemCount: categories.length,
          itemBuilder: (_, index) {
            final category = categories[index];
            final categoryTransactions = getTransactionsWithinCategory(
              category: category,
              transactions: transactions,
            );
            final amountCents = getTransactionsAmount(
              category: category,
              transactions: transactions,
            );

            return StatsCategoryListTile(
              category: category,
              numberOfTransactions: categoryTransactions.length,
              amountCents: amountCents,
            );
          },
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 48),
        ),
      ],
    ),
  );
}
