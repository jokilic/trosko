import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../models/category/category.dart';
import '../../../theme/extensions.dart';
import '../../../util/icons.dart';
import 'home_category.dart';

class HomeCategories extends StatelessWidget {
  final List<Category> categories;
  final Category? activeCategory;
  final void Function(List<Category> newOrder) onReorderCategories;
  final void Function(Category category) onPressedCategory;

  const HomeCategories({
    required this.categories,
    required this.activeCategory,
    required this.onReorderCategories,
    required this.onPressedCategory,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(
      height: 104,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (_, index) {
          ///
          /// CATEGORY
          ///
          if (index < categories.length) {
            final category = categories[index];

            return HomeCategory(
              category: category,
              onPressed: () => onPressedCategory(category),
              color: category.color.withValues(
                alpha: activeCategory == category || activeCategory == null ? 1 : 0.2,
              ),
              highlightColor: category.color.withValues(
                alpha: activeCategory == category || activeCategory == null ? 1 : 0.2,
              ),
              icon: getRegularIconFromName(category.iconName)?.value,
              text: category.name,
            );
          }

          ///
          /// ADD CATEGORY
          ///
          return HomeCategory(
            category: null,
            color: context.colors.buttonBackground,
            highlightColor: context.colors.listTileBackground,
            icon: PhosphorIcons.plus(),
            text: 'homeAddCategory'.tr(),
            hasBorder: false,
          );
        },
      ),
    ),
  );
}
