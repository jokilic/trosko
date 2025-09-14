import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/enums.dart';
import '../../models/transaction/transaction.dart';
import '../../routing.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import '../../util/group_transactions.dart';
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
      afterRegister: (controller) => controller.init(),
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
    final hive = watchIt<HiveService>();

    final allTransactions = hive.value.transactions;
    final categories = hive.value.categories;

    final state = watchIt<HomeController>().value;

    final items = state.datesAndTransactions;

    final activeMonth = state.activeMonth;
    final activeCategory = state.activeCategory;

    return Scaffold(
      floatingActionButton: categories.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => openTransaction(
                context,
                passedTransaction: null,
                categories: categories,
                onTransactionUpdated: controller.updateState,
              ),
              label: Text(
                'Add new'.toUpperCase(),
                style: context.textStyles.homeFloatingActionButton,
              ),
              icon: Icon(
                Icons.payments_outlined,
                color: context.colors.text,
                size: 32,
              ),
            )
          : null,
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
                  Icons.settings_rounded,
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
            months: getMonthsForChips(
              transactions: allTransactions,
              locale: 'hr',
            ),
            activeMonth: activeMonth,
            onChipPressed: (month) => controller.updateState(
              newMonth: month,
            ),
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
            activeCategory: activeCategory,
            onPressedCategory: (category) => controller.updateState(
              newCategory: category,
            ),
            onLongPressedCategory: (category) => openCategory(
              context,
              passedCategory: category,
            ),
            onPressedAdd: () => openCategory(
              context,
              passedCategory: null,
            ),
          ),

          ///
          /// TRANSACTIONS
          ///
          if (items.isNotEmpty)
            SliverList.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];

                ///
                /// DATE TITLE
                ///
                if (item is DateGroup) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(28, 28, 28, 12),
                    child: Text(
                      getGroupLabel(item),
                      style: context.textStyles.homeTitle,
                    ),
                  );
                }

                ///
                /// TRANSACTION
                ///
                if (item is Transaction) {
                  final category = categories.where((category) => category.id == item.categoryId).toList().firstOrNull;

                  return HomeTransactionWidget(
                    onPressed: () => openTransaction(
                      context,
                      passedTransaction: item,
                      categories: categories,
                      onTransactionUpdated: controller.updateState,
                    ),
                    transaction: item,
                    category: category,
                  );
                }

                return const SizedBox.shrink();
              },
            )
          else
            SliverPadding(
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
                      style: context.textStyles.homeTitle,
                    ),
                  ],
                ),
              ),
            ),

          ///
          /// BOTTOM SPACING
          ///
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }
}
