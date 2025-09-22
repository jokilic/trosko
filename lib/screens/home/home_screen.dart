import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../models/day_header/day_header.dart';
import '../../models/transaction/transaction.dart';
import '../../routing.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/currency.dart';
import '../../util/dependencies.dart';
import '../../util/months.dart';
import '../../widgets/trosko_app_bar.dart';
import 'home_controller.dart';
import 'widgets/home_categories.dart';
import 'widgets/home_month_chips.dart';
import 'widgets/home_transaction_list_tile.dart';

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
        firebase: getIt.get<FirebaseService>(),
      ),
      afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<HomeController>(
      afterUnregister: (controller) => controller.onDispose(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = getIt.get<HomeController>();
    final hive = watchIt<HiveService>();

    final allTransactions = hive.value.transactions;
    final categories = hive.value.categories;
    final name = hive.value.username;

    final state = watchIt<HomeController>().value;

    final items = state.datesAndTransactions;

    final activeMonth = state.activeMonth;
    final activeCategory = state.activeCategory;

    return Scaffold(
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: context.colors.buttonBackground,
        ),
        child: Animate(
          autoPlay: false,
          onInit: (controller) => homeController.shakeFabController = controller,
          effects: const [
            ShakeEffect(
              curve: Curves.easeIn,
              duration: TroskoDurations.animation,
            ),
          ],
          child: FloatingActionButton.extended(
            onPressed: categories.isNotEmpty
                ? () {
                    HapticFeedback.lightImpact();

                    openTransaction(
                      context,
                      passedTransaction: null,
                      categories: categories,
                      onTransactionUpdated: homeController.updateState,
                    );
                  }
                : () {
                    HapticFeedback.lightImpact();
                    homeController.triggerFabAnimation();
                  },
            backgroundColor: categories.isNotEmpty ? context.colors.buttonPrimary : context.colors.disabledBackground,
            foregroundColor: categories.isNotEmpty ? context.colors.text : context.colors.disabledText,
            label: Text(
              'Add expense'.toUpperCase(),
              style: context.textStyles.homeFloatingActionButton.copyWith(
                color: categories.isNotEmpty ? context.colors.text : context.colors.disabledText,
              ),
            ),
            icon: PhosphorIcon(
              PhosphorIcons.coins(),
              color: categories.isNotEmpty ? context.colors.text : context.colors.disabledText,
              size: 32,
            ),
          ),
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
                onPressed: () async {
                  await homeController.logOut();
                  openLogin(context);
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  highlightColor: context.colors.buttonBackground,
                ),
                icon: PhosphorIcon(
                  PhosphorIcons.handWaving(
                    PhosphorIconsStyle.bold,
                  ),
                  color: context.colors.text,
                  size: 28,
                ),
              ),
            ],
            smallTitle: (name?.isNotEmpty ?? false) ? 'Hello, $name' : 'Hello',
            bigTitle: (name?.isNotEmpty ?? false) ? 'Hello, $name' : 'Hello',
            bigSubtitle:
                'Today is ${DateFormat(
                  'd. MMMM y.',
                  'hr',
                ).format(DateTime.now())}',
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
            onChipPressed: (month) {
              HapticFeedback.lightImpact();
              homeController.updateState(
                newMonth: month,
              );
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
            onPressedCategory: (category) {
              HapticFeedback.lightImpact();
              homeController.updateState(
                newCategory: category,
              );
            },
            onLongPressedCategory: (category) {
              HapticFeedback.lightImpact();
              openCategory(
                context,
                passedCategory: category,
              );
            },
            onPressedAdd: () {
              HapticFeedback.lightImpact();
              openCategory(
                context,
                passedCategory: null,
              );
            },
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
                /// DAY HEADER
                ///
                if (item is DayHeader) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(28, index == 0 ? 8 : 28, 28, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///
                        /// DAY
                        ///
                        Expanded(
                          child: Text(
                            item.label,
                            style: context.textStyles.homeTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        ///
                        /// AMOUNT
                        ///
                        Text.rich(
                          TextSpan(
                            text: formatCentsToCurrency(
                              item.amountCents,
                            ),
                            children: [
                              TextSpan(
                                text: '€',
                                style: context.textStyles.homeTitleEuro,
                              ),
                            ],
                          ),
                          style: context.textStyles.homeTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }

                ///
                /// TRANSACTION
                ///
                if (item is Transaction) {
                  final category = categories.where((category) => category.id == item.categoryId).toList().firstOrNull;

                  return HomeTransactionListTile(
                    onLongPressed: () {
                      HapticFeedback.lightImpact();
                      openTransaction(
                        context,
                        passedTransaction: item,
                        categories: categories,
                        onTransactionUpdated: homeController.updateState,
                      );
                    },
                    onDeletePressed: () {
                      HapticFeedback.lightImpact();
                      homeController.deleteTransaction(
                        transaction: item,
                      );
                    },
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
                    PhosphorIcon(
                      PhosphorIcons.coins(),
                      color: context.colors.text,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
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
