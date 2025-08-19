import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../routing.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/currency.dart';
import '../../util/dependencies.dart';
import 'home_controller.dart';

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
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => openTransaction(
          context,
          passedTransaction: null,
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              /// TITLE
              ///
              Text(
                'Hello 👋🏼',
                style: context.textStyles.appBarTitle,
              ),
              const SizedBox(height: 12),

              ///
              /// TRANSACTIONS
              ///
              Expanded(
                child: ListView.separated(
                  itemCount: transactions.length,
                  itemBuilder: (_, index) {
                    final transaction = transactions[index];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        transaction.name,
                        style: context.textStyles.homeTransactionTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        transaction.note ?? '--',
                        style: context.textStyles.homeTransactionSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        formatCurrency(transaction.amountCents),
                        style: context.textStyles.appBarTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => Divider(
                    color: context.colors.text,
                  ),
                ),
              ),

              Text('Transactions -> ${transactions.length}'),
              Text('Categories -> ${categories.length}'),
            ],
          ),
        ),
      ),
    );
  }
}
