import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../constants/durations.dart';
import '../../../models/category/category.dart';
import '../../../theme/extensions.dart';
import '../../../util/icons.dart';
import 'home_category.dart';

class HomeCategories extends StatelessWidget {
  final bool isExpanded;
  final List<Category> categories;
  final List<Category>? activeCategories;
  final void Function(List<Category> newOrder) onReorderCategories;
  final void Function(Category category) onPressedCategory;

  const HomeCategories({
    required this.isExpanded,
    required this.categories,
    required this.activeCategories,
    required this.onReorderCategories,
    required this.onPressedCategory,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
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

          return Animate(
            key: ValueKey(isExpanded),
            effects: const [
              ScaleEffect(
                curve: Curves.easeIn,
                duration: TroskoDurations.animation,
              ),
            ],
            child: HomeCategory(
              category: category,
              onPressed: () => onPressedCategory(category),
              color: category.color.withValues(
                alpha: (activeCategories?.isEmpty ?? true) || (activeCategories?.contains(category) ?? false) ? 1 : 0.2,
              ),
              highlightColor: category.color.withValues(alpha: 0.2),
              icon: getRegularIconFromName(category.iconName)?.value,
              text: category.name,
            ),
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
          text: 'homeAdd'.tr(),
          hasBorder: false,
        );
      },
    ),
  );
}
