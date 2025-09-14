import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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

    final validated = state.nameValid && state.categoryColor != null;

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
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: context.colors.buttonBackground,
                highlightColor: context.colors.buttonBackground,
              ),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: context.colors.text,
                size: 28,
              ),
            ),
            actionWidgets: [
              if (widget.passedCategory != null)
                IconButton(
                  onPressed: () async {
                    await controller.deleteCategory();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: context.colors.delete,
                    size: 28,
                  ),
                ),
            ],
            smallTitle: widget.passedCategory != null ? 'Update category' : 'New category',
            bigTitle: widget.passedCategory != null ? 'Update category' : 'New category',
            bigSubtitle: widget.passedCategory != null ? 'Edit details of an existing category' : 'Create a category to track your expenses',
          ),

          ///
          /// CONTENT
          ///
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 12),

                ///
                /// CATEGORY
                ///
                Container(
                  height: 104,
                  width: 104,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: chosenColor,
                    border: Border.all(
                      color: context.colors.text,
                      width: 2.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                ///
                /// NAME TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    autofocus: true,
                    controller: controller.nameTextEditingController,
                    labelText: 'Category name',
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
                  child: MaterialColorPicker(
                    allowShades: false,
                    onMainColorChange: (newColorSwatch) {
                      if (newColorSwatch != null) {
                        controller.colorChanged(newColorSwatch);
                      }
                    },
                    selectedColor: chosenColor,
                    alignment: WrapAlignment.center,
                    circleSize: 56,
                    elevation: 0,
                    iconSelected: Icons.check_rounded,
                    physics: const BouncingScrollPhysics(),
                    spacing: 12,
                  ),
                ),
              ],
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const Spacer(),

                ///
                /// ADD CATEGORY BUTTON
                ///
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
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
                      backgroundColor: chosenColor,
                      foregroundColor: context.colors.listTileBackground,
                      disabledBackgroundColor: context.colors.buttonBackground,
                      disabledForegroundColor: context.colors.listTileBackground,
                    ),
                    child: Text(
                      widget.passedCategory != null ? 'Update category'.toUpperCase() : 'Add category'.toUpperCase(),
                    ),
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
