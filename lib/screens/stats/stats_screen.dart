import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../constants/durations.dart';
import '../../models/category/category.dart';
import '../../models/location/location.dart';
import '../../models/month/month.dart';
import '../../models/transaction/transaction.dart';
import '../../theme/extensions.dart';
import '../../util/icons.dart';
import '../../util/stats.dart';
import '../../widgets/trosko_app_bar.dart';
import 'widgets/stats_all_list_tile.dart';
import 'widgets/stats_category_list_tile.dart';
import 'widgets/stats_location_list_tile.dart';

enum StatsSection {
  categories,
  locations,
}

class StatsScreen extends StatefulWidget {
  final Month month;
  final List<Transaction> transactions;
  final List<Category> categories;
  final List<Location> locations;

  const StatsScreen({
    required this.month,
    required this.transactions,
    required this.categories,
    required this.locations,
    required super.key,
  });

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  var statsSection = StatsSection.categories;

  void toggleStatsSection() => setState(
    () => statsSection = statsSection == StatsSection.categories ? StatsSection.locations : StatsSection.categories,
  );

  String getBigSubtitleText() {
    if (widget.month.isAll) {
      return statsSection == StatsSection.categories ? 'statsSubtitleCategoryAll'.tr() : 'statsSubtitleLocationAll'.tr();
    }

    return statsSection == StatsSection.categories ? 'statsSubtitleCategory'.tr() : 'statsSubtitleLocation'.tr();
  }

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
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              highlightColor: context.colors.buttonBackground,
            ),
            icon: PhosphorIcon(
              getPhosphorIcon(
                PhosphorIcons.arrowLeft,
                isDuotone: false,
                isBold: true,
              ),
              color: context.colors.text,
              duotoneSecondaryColor: context.colors.buttonPrimary,
              size: 28,
            ),
          ),
          actionWidgets: [
            ///
            /// TOGGLE CATEGORIES / LOCATIONS
            ///
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                toggleStatsSection();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                highlightColor: context.colors.buttonBackground,
              ),
              icon: PhosphorIcon(
                getPhosphorIcon(
                  statsSection == StatsSection.categories ? PhosphorIcons.shapes : PhosphorIcons.mapTrifold,
                  isDuotone: false,
                  isBold: true,
                ),
                color: context.colors.text,
                duotoneSecondaryColor: context.colors.buttonPrimary,
                size: 28,
              ),
            ),
          ],
          smallTitle: widget.month.isAll
              ? 'statsTitleAll'.tr()
              : 'statsTitle'.tr(
                  args: [widget.month.label],
                ),
          bigTitle: widget.month.isAll
              ? 'statsTitleAll'.tr()
              : 'statsTitle'.tr(
                  args: [widget.month.label],
                ),
          bigSubtitle: getBigSubtitleText(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 8),
        ),

        ///
        /// ALL
        ///
        SliverToBoxAdapter(
          child: StatsAllListTile(
            numberOfTransactions: widget.transactions.length,
            amountCents: widget.transactions.fold<int>(0, (s, t) => s + t.amountCents),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),

        ///
        /// CATEGORIES
        ///
        if (statsSection == StatsSection.categories)
          SliverList.builder(
            itemCount: widget.categories.length,
            itemBuilder: (_, index) {
              final category = widget.categories[index];
              final categoryTransactions = getTransactionsWithinCategory(
                category: category,
                transactions: widget.transactions,
              );
              final amountCents = getCategoryTransactionsAmount(
                category: category,
                transactions: widget.transactions,
              );

              return Animate(
                key: ValueKey(category),
                delay: Duration(milliseconds: index * 50),
                effects: const [
                  FadeEffect(
                    curve: Curves.easeIn,
                    duration: TroskoDurations.animation,
                  ),
                ],
                child: StatsCategoryListTile(
                  category: category,
                  numberOfTransactions: categoryTransactions.length,
                  amountCents: amountCents,
                ),
              );
            },
          )
        ///
        /// LOCATIONS
        ///
        else
          SliverList.builder(
            itemCount: widget.locations.length,
            itemBuilder: (_, index) {
              final location = widget.locations[index];
              final locationTransactions = getTransactionsWithinLocation(
                location: location,
                transactions: widget.transactions,
              );
              final amountCents = getLocationTransactionsAmount(
                location: location,
                transactions: widget.transactions,
              );

              return Animate(
                key: ValueKey(location),
                delay: Duration(milliseconds: index * 50),
                effects: const [
                  FadeEffect(
                    curve: Curves.easeIn,
                    duration: TroskoDurations.animation,
                  ),
                ],
                child: StatsLocationListTile(
                  location: location,
                  numberOfTransactions: locationTransactions.length,
                  amountCents: amountCents,
                ),
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
