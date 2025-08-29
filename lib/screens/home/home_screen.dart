import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../routing.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import '../../util/months.dart';
import '../../widgets/trosko_app_bar.dart';
import 'home_controller.dart';
import 'widgets/home_categories.dart';
import 'widgets/home_month_chips.dart';
import 'widgets/home_transaction_widget.dart';

class HomeScreen extends WatchingStatefulWidget {
  const HomeScreen({
    required super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<HomeController>(
      () => HomeController(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
      ),
    );
  }

  @override
  void dispose() {
    getIt.unregister<HomeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<HomeController>();

    final categories = watchIt<HiveService>().value.categories;

    final state = watchIt<HomeController>().value;
    final transactions = state.transactions;
    final activeMonth = state.activeMonth;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openTransaction(
          context,
          passedTransaction: null,
          categories: categories,
        ),
        label: Text(
          'New pokémon'.toUpperCase(),
        ),
        icon: const Icon(
          Icons.catching_pokemon_rounded,
        ),
      ),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          ///
          /// APP BAR
          ///
          TroskoAppBar(
            actionWidgets: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.catching_pokemon_rounded,
                  color: context.colors.text,
                  size: 28,
                ),
              ),
            ],
            smallTitle: 'Hello, Josip 👋🏼',
            bigTitle: 'Hello, Josip 👋🏼',
            bigSubtitle: 'Welcome to Troško',
          ),

          ///
          /// MONTH CHIPS
          ///
          HomeMonthChips(
            months: getMonthsFromJan2024(
              locale: 'hr',
            ),
            activeMonth: activeMonth,
            onChipPressed: controller.updateStateByMonth,
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          ///
          /// CATEGORIES TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Categories',
                style: context.textStyles.homeTitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          ///
          /// CATEGORIES
          ///
          HomeCategories(
            categories: categories,
            onPressedCategory: (category) => openCategory(
              context,
              passedCategory: category,
            ),
            onPressedAdd: () => openCategory(
              context,
              passedCategory: null,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          ///
          /// TRANSACTIONS TITLE
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Transactions',
                style: context.textStyles.homeTitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          ///
          /// TRANSACTIONS
          ///
          if (transactions.isNotEmpty)
            SliverList.separated(
              itemCount: transactions.length,
              itemBuilder: (_, index) {
                final transaction = transactions[index];
                final category = categories.where((category) => category.id == transaction.categoryId).toList().firstOrNull;

                return Animate(
                  key: ValueKey(activeMonth),
                  effects: [
                    FadeEffect(
                      duration: TroskoDurations.animationDuration,
                      delay: (75 * index).ms,
                      curve: Curves.easeIn,
                    ),
                  ],
                  child: HomeTransactionWidget(
                    onPressed: () => openTransaction(
                      context,
                      passedTransaction: transaction,
                      categories: categories,
                    ),
                    transaction: transaction,
                    category: category,
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(
                height: 0,
                color: context.colors.text.withValues(alpha: 0.1),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Animate(
                  key: ValueKey(activeMonth),
                  effects: const [
                    FadeEffect(
                      duration: TroskoDurations.animationDuration,
                      delay: TroskoDurations.animationDelay,
                      curve: Curves.easeIn,
                    ),
                  ],
                  child: Column(
                    children: [
                      Icon(
                        Icons.money_off_rounded,
                        color: context.colors.text,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No transactions',
                        textAlign: TextAlign.center,
                        style: context.textStyles.homeTitle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
