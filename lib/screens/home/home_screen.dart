import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../routing.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
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
            onPressedIcon: () {
              openTransaction(
                context,
                passedTransaction: null,
                categories: categories,
              );
            },
            icon: Icons.monetization_on_rounded,
            smallTitle: 'Welcome to Troško',
            bigTitle: 'Welcome to Troško',
            bigSubtitle: "How you doin'?",
          ),

          ///
          /// CONTENT
          ///
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: transactions.length,
              itemBuilder: (_, index) {
                final transaction = transactions[index];
                final category = categories.where((category) => category.id == transaction.categoryId).toList().firstOrNull;

                return HomeTransactionWidget(
                  transaction: transaction,
                  category: category,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
