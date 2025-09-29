import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import '../../util/string.dart';
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
      afterRegister: (controller) => WidgetsBinding.instance.addPostFrameCallback(
        (_) => controller.init(
          locale: context.locale.languageCode,
        ),
      ),
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

    final now = DateTime.now();
    final greeting = getGreeting(now);

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
                      onTransactionUpdated: () => homeController.updateState(
                        locale: context.locale.languageCode,
                      ),
                    );
                  }
                : () {
                    HapticFeedback.lightImpact();
                    homeController.triggerFabAnimation();
                  },
            backgroundColor: categories.isNotEmpty ? context.colors.buttonPrimary : context.colors.disabledBackground,
            foregroundColor: categories.isNotEmpty ? context.colors.text : context.colors.disabledText,
            label: Text(
              'homeAddExpense'.tr().toUpperCase(),
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
                onPressed: () {
                  HapticFeedback.lightImpact();
                  openSettings(context);
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  highlightColor: context.colors.buttonBackground,
                ),
                icon: PhosphorIcon(
                  PhosphorIcons.gearSix(
                    PhosphorIconsStyle.bold,
                  ),
                  color: context.colors.text,
                  size: 28,
                ),
              ),
            ],
            smallTitle: 'homeTodayIs'.tr(
              args: [
                DateFormat(
                  'd. MMMM y.',
                  context.locale.countryCode,
                ).format(now),
              ],
            ),
            bigTitle: (name?.isNotEmpty ?? false) ? '$greeting, $name' : greeting,
            bigSubtitle: 'homeTodayIs'.tr(
              args: [
                DateFormat(
                  'd. MMMM y.',
                  context.locale.countryCode,
                ).format(now),
              ],
            ),
          ),

          ///
          /// MONTH CHIPS
          ///
          HomeMonthChips(
            months: getMonthsForChips(
              transactions: allTransactions,
              locale: context.locale.languageCode,
            ),
            activeMonth: activeMonth,
            onChipPressed: (month) {
              HapticFeedback.lightImpact();
              homeController.updateState(
                newMonth: month,
                locale: context.locale.languageCode,
              );
            },
            onChipLongPressed: (month) {
              if (month != null) {
                final transactions = homeController.getAllTransactionsFromMonth(month);

                openStats(
                  context,
                  month: month,
                  transactions: transactions,
                  categories: categories,
                );
              }
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
                'homeCategories'.tr(),
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
                locale: context.locale.languageCode,
              );
            },
            onLongPressedCategory: (category) => openCategory(
              context,
              passedCategory: category,
            ),
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
                              locale: context.locale.languageCode,
                            ),
                            children: [
                              TextSpan(
                                text: 'homeCurrency'.tr(),
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
                    onLongPressed: () => openTransaction(
                      context,
                      passedTransaction: item,
                      categories: categories,
                      onTransactionUpdated: () => homeController.updateState(
                        locale: context.locale.languageCode,
                      ),
                    ),
                    onDeletePressed: () {
                      HapticFeedback.lightImpact();
                      homeController.deleteTransaction(
                        transaction: item,
                        locale: context.locale.languageCode,
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
                      'homeNoExpenses'.tr(),
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
