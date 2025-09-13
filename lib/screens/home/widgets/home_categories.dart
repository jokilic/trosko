import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/durations.dart';
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
      height: 88,
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
            return Animate(
              effects: [
                FadeEffect(
                  duration: TroskoDurations.animationDuration,
                  delay: index <= 5 ? (75 * index).ms : 0.ms,
                  curve: Curves.easeIn,
                ),
              ],
              child: HomeCategory(
                onPressed: () => onPressedCategory(category),
                onLongPressed: () => onLongPressedCategory(category),
                color: category.color.withValues(alpha: activeCategory == category ? 1 : 0.2),
                icon: Icons.catching_pokemon_rounded,
                text: category.name,
              ),
            );
          }

          ///
          /// ADD NEW CATEGORY
          ///
          return Animate(
            effects: [
              FadeEffect(
                duration: 150.ms,
                delay: index <= 5 ? (75 * index).ms : 0.ms,
              ),
            ],
            child: HomeCategory(
              onPressed: onPressedAdd,
              color: context.colors.buttonBackground,
              icon: Icons.add_rounded,
              text: 'Add',
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 24),
      ),
    ),
  );
}

class HomeCategory extends StatelessWidget {
  final Function() onPressed;
  final Function()? onLongPressed;
  final Color color;
  final IconData icon;
  final String text;

  const HomeCategory({
    required this.onPressed,
    required this.color,
    required this.icon,
    required this.text,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(
      maxWidth: 96,
    ),
    child: Column(
      children: [
        IconButton(
          onPressed: onPressed,
          onLongPress: onLongPressed,
          style: IconButton.styleFrom(
            backgroundColor: color,
            highlightColor: color.withValues(alpha: 0.1),
          ),
          icon: Icon(icon),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: context.textStyles.homeCategoryTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
