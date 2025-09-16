import 'package:flutter/material.dart';

import '../../../models/category/category.dart';
import '../../../theme/theme.dart';

class HomeCategories extends StatelessWidget {
  final List<Category> categories;
  final Category? activeCategory;
  final Function(Category category) onPressedCategory;
  final Function(Category category) onLongPressedCategory;
  final Function() onPressedAdd;

  const HomeCategories({
    required this.categories,
    required this.activeCategory,
    required this.onPressedCategory,
    required this.onLongPressedCategory,
    required this.onPressedAdd,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(
      height: 104,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (_, index) {
          final category = categories.elementAtOrNull(index);

          ///
          /// CATEGORY
          ///
          if (category != null) {
            return HomeCategory(
              onPressed: () => onPressedCategory(category),
              onLongPressed: () => onLongPressedCategory(category),
              color: category.color.withValues(
                alpha: activeCategory == category || activeCategory == null ? 1 : 0.2,
              ),
              highlightColor: category.color.withValues(
                alpha: activeCategory == category || activeCategory == null ? 1 : 0.2,
              ),
              text: category.name,
            );
          }

          ///
          /// ADD NEW CATEGORY
          ///
          return HomeCategory(
            onPressed: onPressedAdd,
            color: context.colors.buttonBackground,
            highlightColor: context.colors.listTileBackground,
            icon: Icons.add_rounded,
            text: 'Add',
            hasBorder: false,
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 4),
      ),
    ),
  );
}

class HomeCategory extends StatelessWidget {
  final Function() onPressed;
  final Function()? onLongPressed;
  final Color color;
  final Color highlightColor;
  final IconData? icon;
  final String text;
  final bool hasBorder;

  const HomeCategory({
    required this.onPressed,
    required this.color,
    required this.highlightColor,
    required this.text,
    this.icon,
    this.onLongPressed,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 80,
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: hasBorder ? context.colors.text : color,
              width: 1.5,
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            onLongPress: onLongPressed,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(12),
              backgroundColor: color,
              highlightColor: highlightColor,
              alignment: Alignment.center,
            ),
            icon: Icon(icon),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: context.textStyles.homeCategoryTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
