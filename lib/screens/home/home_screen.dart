import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../routing.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import '../../widgets/trosko_app_bar.dart';
import 'home_controller.dart';
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
    final filters = ['All', 'Tech', 'Design', 'Business', 'Sports', 'Science', 'Music', 'Travel'];

    final state = watchIt<HiveService>().value;

    final transactions = state.transactions;
    final categories = state.categories;

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
          /// MONTH CAROUSEL
          ///
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Transactions',
                style: TextStyle(
                  fontFamily: 'ProductSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 56,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, i) {
                  final label = filters[i];
                  final isSelected = i == 1;

                  return FilterChip(
                    label: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 40,
                      ),
                      child: Text(
                        label,
                        style: context.textStyles.homeMonthChip.copyWith(height: 0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {},
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
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
