import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../models/category/category.dart';
import '../../models/location/location.dart';
import '../../models/month/month.dart';
import '../../models/transaction/transaction.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/extensions.dart';
import '../../util/dependencies.dart';
import '../../util/icons.dart';
import '../../util/stats.dart';
import '../../widgets/trosko_app_bar.dart';
import 'stats_controller.dart';
import 'widgets/stats_all_list_tile.dart';
import 'widgets/stats_categories_graph.dart';
import 'widgets/stats_category_list_tile.dart';
import 'widgets/stats_location_list_tile.dart';
import 'widgets/stats_locations_graph.dart';

class StatsScreen extends WatchingStatefulWidget {
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
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<StatsController>(
      () => StatsController(
        logger: getIt.get<LoggerService>(),
        transactions: widget.transactions,
        categories: widget.categories,
        locations: widget.locations,
      ),
      instanceName: widget.month.label,
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<StatsController>(
      instanceName: widget.month.label,
    );
    super.dispose();
  }

  String getBigSubtitleText({required StatsSection section}) {
    if (widget.month.isAll) {
      return section == StatsSection.categories ? 'statsSubtitleCategoryAll'.tr() : 'statsSubtitleLocationAll'.tr();
    }

    return section == StatsSection.categories ? 'statsSubtitleCategory'.tr() : 'statsSubtitleLocation'.tr();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<StatsController>(
      instanceName: widget.month.label,
    );

    final state = watchIt<StatsController>(
      instanceName: widget.month.label,
    ).value;

    final section = state.section;

    final useColorfulIcons = watchIt<HiveService>().value.settings?.useColorfulIcons ?? false;

    return Scaffold(
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
                  isDuotone: useColorfulIcons,
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
                  controller.toggleStatsSection();
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  highlightColor: context.colors.buttonBackground,
                ),
                icon: PhosphorIcon(
                  getPhosphorIcon(
                    section == StatsSection.categories ? PhosphorIcons.shapes : PhosphorIcons.mapTrifold,
                    isDuotone: useColorfulIcons,
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
            bigSubtitle: getBigSubtitleText(
              section: section,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          ///
          /// CATEGORIES
          ///
          if (section == StatsSection.categories) ...[
            ///
            /// GRAPH
            ///
            SliverToBoxAdapter(
              child: Animate(
                key: ValueKey(section),
                effects: const [
                  FadeEffect(
                    curve: Curves.easeIn,
                    duration: TroskoDurations.animationLong,
                  ),
                ],
                child: StatsCategoriesGraph(
                  categories: widget.categories,
                  useColorfulIcons: useColorfulIcons,
                  instanceName: widget.month.label,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),

            ///
            /// ALL
            ///
            SliverToBoxAdapter(
              child: StatsAllListTile(
                useColorfulIcons: useColorfulIcons,
                numberOfTransactions: widget.transactions.length,
                amountCents: widget.transactions.fold<int>(0, (s, t) => s + t.amountCents),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            ///
            /// LIST
            ///
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
                  effects: const [
                    FadeEffect(
                      curve: Curves.easeIn,
                      duration: TroskoDurations.animationLong,
                    ),
                  ],
                  child: StatsCategoryListTile(
                    useColorfulIcons: useColorfulIcons,
                    category: category,
                    numberOfTransactions: categoryTransactions.length,
                    amountCents: amountCents,
                  ),
                );
              },
            ),
          ]
          ///
          /// LOCATIONS
          ///
          else ...[
            ///
            /// GRAPH
            ///
            SliverToBoxAdapter(
              child: Animate(
                key: ValueKey(section),
                effects: const [
                  FadeEffect(
                    curve: Curves.easeIn,
                    duration: TroskoDurations.animationLong,
                  ),
                ],
                child: StatsLocationsGraph(
                  locations: widget.locations,
                  useColorfulIcons: useColorfulIcons,
                  instanceName: widget.month.label,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),

            ///
            /// ALL
            ///
            SliverToBoxAdapter(
              child: StatsAllListTile(
                useColorfulIcons: useColorfulIcons,
                numberOfTransactions: widget.transactions.length,
                amountCents: widget.transactions.fold<int>(0, (s, t) => s + t.amountCents),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            ///
            /// LIST
            ///
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
                  effects: const [
                    FadeEffect(
                      curve: Curves.easeIn,
                      duration: TroskoDurations.animationLong,
                    ),
                  ],
                  child: StatsLocationListTile(
                    useColorfulIcons: useColorfulIcons,
                    location: location,
                    numberOfTransactions: locationTransactions.length,
                    amountCents: amountCents,
                  ),
                );
              },
            ),
          ],

          const SliverToBoxAdapter(
            child: SizedBox(height: 48),
          ),
        ],
      ),
    );
  }
}
