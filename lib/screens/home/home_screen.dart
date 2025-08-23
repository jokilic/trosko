import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../routing.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import '../../util/months.dart';
import '../../widgets/trosko_app_bar.dart';
import 'home_controller.dart';
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
    final state = watchIt<HiveService>().value;

    final transactions = state.transactions;
    final categories = state.categories;

    return Scaffold(
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
                onPressed: () => openTransaction(
                  context,
                  passedTransaction: null,
                  categories: categories,
                ),
                icon: Icon(
                  Icons.monetization_on_rounded,
                  color: context.colors.text,
                  size: 28,
                ),
              ),
            ],
            smallTitle: 'Welcome to Troško',
            bigTitle: 'Welcome to Troško',
            bigSubtitle: "How you doin'?",
          ),

          ///
          /// MONTH CHIPS
          ///
          HomeMonthChips(
            months: getMonthsFromJan2024(
              locale: 'hr',
            ),
            activeMonth: getCurrentMonth(
              locale: 'hr',
            ),
            onChipPressed: (newMonth) {
              print('Hello -> $newMonth');
            },
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
                style: context.textStyles.homeNoTransaction,
              ),
            ),
          ),

          ///
          /// TRANSACTIONS
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: transactions.isNotEmpty
                ? SliverList.builder(
                    itemCount: transactions.length,
                    itemBuilder: (_, index) {
                      final transaction = transactions[index];
                      final category = categories.where((category) => category.id == transaction.categoryId).toList().firstOrNull;

                      return HomeTransactionWidget(
                        transaction: transaction,
                        category: category,
                      );
                    },
                  )
                : SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverToBoxAdapter(
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
                            style: context.textStyles.homeNoTransaction,
                          ),
                          Text(
                            'Add some',
                            textAlign: TextAlign.center,
                            style: context.textStyles.homeNoTransaction,
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
