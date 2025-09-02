import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/durations.dart';
import '../../../models/category/category.dart';
import '../../../theme/theme.dart';

class HomeCategories extends StatelessWidget {
  final List<Category> categories;
  final Function(Category category) onPressedCategory;
  final Function() onPressedAdd;

  const HomeCategories({
    required this.categories,
    required this.onPressedCategory,
    required this.onPressedAdd,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(
      height: 96,
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
                  delay: (75 * index).ms,
                  curve: Curves.easeIn,
                ),
              ],
              child: HomeCategory(
                onPressed: () => onPressedCategory(category),
                color: category.color,
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
                delay: (75 * index).ms,
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
  final Color color;
  final IconData icon;
  final String text;

  const HomeCategory({
    required this.onPressed,
    required this.color,
    required this.icon,
    required this.text,
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
          style: IconButton.styleFrom(
            backgroundColor: color,
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
