import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../models/day_header/day_header.dart';
import '../../models/transaction/transaction.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/color.dart';
import '../../util/currency.dart';
import '../../util/dependencies.dart';
import '../../util/months.dart';
import '../../util/stats.dart';
import '../../util/string.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_transaction_list_tile.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import '../stats/stats_screen.dart';
import '../transaction/transaction_screen.dart';
import 'home_controller.dart';
import 'widgets/home_categories.dart';
import 'widgets/home_month_chips.dart';

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
      floatingActionButton: OpenContainer(
        transitionDuration: TroskoDurations.switchAnimation,
        transitionType: ContainerTransitionType.fadeThrough,
        middleColor: context.colors.scaffoldBackground,
        openElevation: 0,
        openColor: context.colors.scaffoldBackground,
        openShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        closedElevation: 0,
        closedColor: context.colors.scaffoldBackground,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        closedBuilder: (context, openContainer) => Theme(
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
                      openContainer();
                    }
                  : () {
                      HapticFeedback.lightImpact();
                      homeController.triggerFabAnimation();
                    },
              backgroundColor: categories.isNotEmpty ? context.colors.buttonPrimary : context.colors.disabledBackground,
              foregroundColor: categories.isNotEmpty
                  ? getWhiteOrBlackColor(
                      backgroundColor: categories.isNotEmpty ? context.colors.buttonPrimary : context.colors.disabledBackground,
                      whiteColor: TroskoColors.lightThemeWhiteBackground,
                      blackColor: TroskoColors.lightThemeBlackText,
                    )
                  : context.colors.disabledText,
              label: Text(
                'homeAddExpense'.tr().toUpperCase(),
                style: context.textStyles.homeFloatingActionButton.copyWith(
                  color: categories.isNotEmpty
                      ? getWhiteOrBlackColor(
                          backgroundColor: categories.isNotEmpty ? context.colors.buttonPrimary : context.colors.disabledBackground,
                          whiteColor: TroskoColors.lightThemeWhiteBackground,
                          blackColor: TroskoColors.lightThemeBlackText,
                        )
                      : context.colors.disabledText,
                ),
              ),
              icon: PhosphorIcon(
                PhosphorIcons.coins(),
                color: categories.isNotEmpty
                    ? getWhiteOrBlackColor(
                        backgroundColor: categories.isNotEmpty ? context.colors.buttonPrimary : context.colors.disabledBackground,
                        whiteColor: TroskoColors.lightThemeWhiteBackground,
                        blackColor: TroskoColors.lightThemeBlackText,
                      )
                    : context.colors.disabledText,
                size: 32,
              ),
            ),
          ),
        ),
        openBuilder: (context, _) => TransactionScreen(
          passedTransaction: null,
          categories: categories,
          passedCategory: activeCategory,
          passedNotificationPayload: null,
          onTransactionUpdated: () => homeController.updateState(
            locale: context.locale.languageCode,
          ),
          key: const ValueKey(null),
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
              ///
              /// SETTINGS
              ///
              OpenContainer(
                transitionDuration: TroskoDurations.switchAnimation,
                transitionType: ContainerTransitionType.fadeThrough,
                middleColor: context.colors.scaffoldBackground,
                openElevation: 0,
                openColor: context.colors.scaffoldBackground,
                openShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                closedElevation: 0,
                closedColor: context.colors.scaffoldBackground,
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                closedBuilder: (context, openContainer) => IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    openContainer();
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
                openBuilder: (context, _) => SettingsScreen(
                  onStateUpdateTriggered: () => homeController.updateState(
                    locale: context.locale.languageCode,
                  ),
                  key: const ValueKey('settings'),
                ),
              ),

              ///
              /// SEARCH
              ///
              OpenContainer(
                transitionDuration: TroskoDurations.switchAnimation,
                transitionType: ContainerTransitionType.fadeThrough,
                middleColor: context.colors.scaffoldBackground,
                openElevation: 0,
                openColor: context.colors.scaffoldBackground,
                openShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                closedElevation: 0,
                closedColor: context.colors.scaffoldBackground,
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                closedBuilder: (context, openContainer) => IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    openContainer();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    highlightColor: context.colors.buttonBackground,
                  ),
                  icon: PhosphorIcon(
                    PhosphorIcons.magnifyingGlass(
                      PhosphorIconsStyle.bold,
                    ),
                    color: context.colors.text,
                    size: 28,
                  ),
                ),
                openBuilder: (context, _) => SearchScreen(
                  categories: categories,
                  onTransactionUpdated: () => homeController.updateState(
                    locale: context.locale.languageCode,
                  ),
                  locale: context.locale.languageCode,
                  key: const ValueKey('search'),
                ),
              ),
            ],
            smallTitle: 'homeTodayIs'.tr(
              args: [
                DateFormat(
                  'd. MMMM y.',
                  context.locale.languageCode,
                ).format(now),
              ],
            ),
            bigTitle: (name?.isNotEmpty ?? false) ? '$greeting, $name' : greeting,
            bigSubtitle: 'homeTodayIs'.tr(
              args: [
                DateFormat(
                  'd. MMMM y.',
                  context.locale.languageCode,
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
            onLongPressed: (month) {
              if (month != null) {
                final transactions = month.isAll ? allTransactions : homeController.getAllTransactionsFromMonth(month);

                return StatsScreen(
                  month: month,
                  transactions: transactions,
                  categories: getSortedCategories(
                    categories: categories,
                    transactions: transactions,
                  ),
                  key: ValueKey(month),
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
            onReorderCategories: hive.updateCategoriesOrder,
            onPressedCategory: (category) {
              HapticFeedback.lightImpact();
              homeController.updateState(
                newCategory: category,
                locale: context.locale.languageCode,
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

                  return TroskoTransactionListTile(
                    onLongPressed: () => TransactionScreen(
                      passedTransaction: item,
                      categories: categories,
                      passedCategory: activeCategory,
                      passedNotificationPayload: null,
                      onTransactionUpdated: () => homeController.updateState(
                        locale: context.locale.languageCode,
                      ),
                      key: ValueKey(item.id),
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
                      'homeNoExpensesTitle'.tr(),
                      textAlign: TextAlign.center,
                      style: context.textStyles.homeTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'homeNoExpensesSubtitle'.tr(),
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
