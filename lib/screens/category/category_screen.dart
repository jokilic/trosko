import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/category/category.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/theme.dart';
import '../../util/dependencies.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_text_field.dart';
import 'category_controller.dart';

class CategoryScreen extends WatchingStatefulWidget {
  final Category? passedCategory;

  const CategoryScreen({
    required this.passedCategory,
    required super.key,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<CategoryController>(
      () => CategoryController(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
        passedCategory: widget.passedCategory,
      ),
      instanceName: widget.passedCategory?.id,
      afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    getIt.unregister<CategoryController>(
      instanceName: widget.passedCategory?.id,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<CategoryController>(
      instanceName: widget.passedCategory?.id,
    );

    final state = watchIt<CategoryController>(
      instanceName: widget.passedCategory?.id,
    ).value;

    final chosenColor = state.categoryColor;

    final validated = state.nameValid && state.categoryColor != null && state.categoryIcon != null;

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
              onPressed: Navigator.of(context).pop,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: context.colors.text,
                size: 28,
              ),
            ),
            smallTitle: widget.passedCategory != null ? 'Update category' : 'New category',
            bigTitle: widget.passedCategory != null ? 'Update category' : 'New category',
            bigSubtitle: "How you doin'?",
          ),

          ///
          /// CONTENT
          ///
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 24),

                ///
                /// NAME TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    autofocus: false,
                    controller: controller.nameTextEditingController,
                    labelText: 'What is the name?',
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// CATEGORY COLOR
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton(
                    onPressed: () => controller.colorChanged(Colors.indigo),
                    style: FilledButton.styleFrom(
                      backgroundColor: chosenColor ?? context.colors.primary,
                      foregroundColor: context.colors.background,
                    ),
                    child: Text(
                      'Category color'.toUpperCase(),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// CATEGORY ICON
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton(
                    onPressed: () => controller.iconChanged('Some icon'),
                    style: FilledButton.styleFrom(
                      backgroundColor: state.categoryIcon != null ? Colors.green : context.colors.primary,
                      foregroundColor: context.colors.background,
                    ),
                    child: Text(
                      'Category icon'.toUpperCase(),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// ADD CATEGORY BUTTON
                ///
                FilledButton(
                  onPressed: validated
                      ? () async {
                          await controller.addCategory();
                          Navigator.of(context).pop();
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      28,
                      24,
                      MediaQuery.paddingOf(context).bottom + 12,
                    ),
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.background,
                    disabledBackgroundColor: context.colors.text.withValues(alpha: 0.4),
                    disabledForegroundColor: context.colors.background,
                  ),
                  child: Text(
                    'Add category'.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
