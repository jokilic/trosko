import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/category/category.dart';
import '../../models/day_header/day_header.dart';
import '../../models/location/location.dart';
import '../../models/transaction/transaction.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/extensions.dart';
import '../../util/currency.dart';
import '../../util/dependencies.dart';
import '../../util/icons.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_text_field.dart';
import '../../widgets/trosko_transaction_list_tile.dart';
import '../transaction/transaction_screen.dart';
import 'search_controller.dart';

class SearchScreen extends WatchingStatefulWidget {
  final List<Category> categories;
  final List<Location> locations;
  final Function() onTransactionUpdated;
  final String locale;

  const SearchScreen({
    required this.categories,
    required this.locations,
    required this.onTransactionUpdated,
    required this.locale,
    required super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<SearchController>(
      () => SearchController(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
        firebase: getIt.get<FirebaseService>(),
        locale: widget.locale,
      ),
      afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<SearchController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchController = getIt.get<SearchController>();

    final state = watchIt<SearchController>().value;

    final useColorfulIcons = watchIt<HiveService>().value.settings?.useColorfulIcons ?? false;

    final items = state.datesAndTransactions;
    final isTextFieldEmpty = state.isTextFieldEmpty;

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
            smallTitle: 'searchTitle'.tr(),
            bigTitle: 'searchTitle'.tr(),
            bigSubtitle: 'searchSubtitle'.tr(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 4),
          ),

          ///
          /// SEARCH TEXT FIELD
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: TroskoTextField(
                autofocus: true,
                controller: searchController.searchTextEditingController,
                labelText: 'searchTextField'.tr(),
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 28),
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
                  final category = widget.categories.where((category) => category.id == item.categoryId).toList().firstOrNull;
                  final location = widget.locations.where((location) => location.id == item.locationId).toList().firstOrNull;

                  return TroskoTransactionListTile(
                    useColorfulIcons: useColorfulIcons,
                    onLongPressed: () => TransactionScreen(
                      passedTransaction: item,
                      passedAITransaction: null,
                      categories: widget.categories,
                      locations: widget.locations,
                      passedCategory: null,
                      passedLocation: null,
                      passedNotificationPayload: null,
                      onTransactionUpdated: () {
                        searchController.updateState(
                          locale: context.locale.languageCode,
                        );
                        widget.onTransactionUpdated();
                      },
                      key: ValueKey(item.id),
                    ),
                    onDeletePressed: () {
                      HapticFeedback.lightImpact();
                      searchController.deleteTransaction(
                        transaction: item,
                        locale: context.locale.languageCode,
                      );
                      widget.onTransactionUpdated();
                    },
                    transaction: item,
                    category: category,
                    location: location,
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
                      getPhosphorIcon(
                        PhosphorIcons.magnifyingGlass,
                        isDuotone: useColorfulIcons,
                        isBold: true,
                      ),
                      color: context.colors.text,
                      duotoneSecondaryColor: context.colors.buttonPrimary,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isTextFieldEmpty ? 'searchEmptyTitle'.tr() : 'searchNothingFoundTitle'.tr(),
                      textAlign: TextAlign.center,
                      style: context.textStyles.homeTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isTextFieldEmpty ? 'searchEmptySubtitle'.tr() : 'searchNothingFoundSubtitle'.tr(),
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
