import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/colors.dart';
import '../../models/category/category.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/color.dart';
import '../../util/dependencies.dart';
import '../../widgets/icon_list_tile.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_text_field.dart';
import 'category_controller.dart';
import 'widgets/category_colors.dart';
import 'widgets/category_custom_color_modal.dart';

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
        firebase: getIt.get<FirebaseService>(),
        passedCategory: widget.passedCategory,
      ),
      instanceName: widget.passedCategory?.id,
      afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<CategoryController>(
      instanceName: widget.passedCategory?.id,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryController = getIt.get<CategoryController>(
      instanceName: widget.passedCategory?.id,
    );

    final state = watchIt<CategoryController>(
      instanceName: widget.passedCategory?.id,
    ).value;

    final categoryName = state.categoryName;
    final categoryColor = state.categoryColor;
    final categoryIcon = state.categoryIcon;

    final searchedIcons = state.searchedIcons;

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
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                highlightColor: context.colors.buttonBackground,
              ),
              icon: PhosphorIcon(
                PhosphorIcons.arrowLeft(
                  PhosphorIconsStyle.bold,
                ),
                color: context.colors.text,
                size: 28,
              ),
            ),
            actionWidgets: [
              if (widget.passedCategory != null)
                IconButton(
                  onPressed: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );
                    await categoryController.deleteCategory();
                    Navigator.of(context).pop();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    highlightColor: context.colors.buttonBackground,
                  ),
                  icon: PhosphorIcon(
                    PhosphorIcons.trash(
                      PhosphorIconsStyle.bold,
                    ),
                    color: context.colors.delete,
                    size: 28,
                  ),
                ),
            ],
            smallTitle: widget.passedCategory != null ? 'categoryUpdateTitle'.tr() : 'categoryNewTitle'.tr(),
            bigTitle: widget.passedCategory != null ? 'categoryUpdateTitle'.tr() : 'categoryNewTitle'.tr(),
            bigSubtitle: widget.passedCategory != null ? 'categoryUpdateSubtitle'.tr() : 'categoryNewSubtitle'.tr(),
          ),

          ///
          /// CONTENT
          ///
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 8),

                ///
                /// CATEGORY
                ///
                Column(
                  children: [
                    Container(
                      height: 104,
                      width: 104,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: categoryColor,
                        border: Border.all(
                          color: categoryColor ?? context.colors.text,
                          width: 1.5,
                        ),
                      ),
                      child: categoryIcon != null
                          ? PhosphorIcon(
                              categoryIcon.value,
                              color: getWhiteOrBlackColor(
                                backgroundColor: categoryColor ?? context.colors.scaffoldBackground,
                                whiteColor: TroskoColors.lightThemeWhiteBackground,
                                blackColor: TroskoColors.lightThemeBlackText,
                              ),
                              size: 56,
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categoryName ?? '',
                      style: context.textStyles.categoryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                ///
                /// CATEGORY TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'categoryTitle'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// TITLE TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    controller: categoryController.nameTextEditingController,
                    labelText: 'categoryTitle'.tr(),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// COLOR TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'categoryColor'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// CATEGORY COLORS
                ///
                CategoryColors(
                  colors: categoryColors,
                  activeColor: categoryColor,
                  onPressedColor: (color) {
                    HapticFeedback.lightImpact();
                    categoryController.colorChanged(color);
                  },
                  onPressedAdd: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );

                    /// Show [CategoryCustomColorModal]
                    final color = await showModalBottomSheet<Color>(
                      context: context,
                      backgroundColor: context.colors.scaffoldBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      builder: (context) => CategoryCustomColorModal(
                        startingColor: context.colors.buttonPrimary,
                        key: const ValueKey('custom-color-modal'),
                      ),
                    );

                    /// `color` exists
                    if (color != null) {
                      categoryController.colorChanged(color);
                    }
                  },
                ),
                const SizedBox(height: 28),

                ///
                /// ICON TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'categoryLocationIcon'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// CATEGORY ICON TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    controller: categoryController.iconTextEditingController,
                    labelText: 'categoryLocationIcon'.tr(),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 20),

                ///
                /// CATEGORY ICONS
                ///
                if (searchedIcons?.isNotEmpty ?? false)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.colors.listTileBackground,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: searchedIcons?.length,
                      itemBuilder: (_, index) {
                        final icon = searchedIcons![index];

                        return IconListTile(
                          isActive: categoryIcon?.key == icon.key,
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            categoryController.iconChanged(icon);
                          },
                          icon: icon,
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: validated
                ? () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );
                    await categoryController.addCategory();
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
              backgroundColor: context.colors.buttonPrimary,
              foregroundColor: getWhiteOrBlackColor(
                backgroundColor: context.colors.buttonPrimary,
                whiteColor: TroskoColors.lightThemeWhiteBackground,
                blackColor: TroskoColors.lightThemeBlackText,
              ),
              overlayColor: context.colors.buttonBackground,
              disabledBackgroundColor: context.colors.disabledBackground,
              disabledForegroundColor: context.colors.disabledText,
            ),
            child: Text(
              widget.passedCategory != null ? 'categoryUpdateButton'.tr().toUpperCase() : 'categoryAddButton'.tr().toUpperCase(),
            ),
          ),
        ),
      ),
    );
  }
}
