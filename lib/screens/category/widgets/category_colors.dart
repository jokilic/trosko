import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../theme/extensions.dart';
import 'category_color.dart';

class CategoryColors extends StatelessWidget {
  final List<Color> colors;
  final Color? activeColor;
  final Function(Color color) onPressedColor;
  final Function() onPressedAdd;

  const CategoryColors({
    required this.colors,
    required this.activeColor,
    required this.onPressedColor,
    required this.onPressedAdd,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: 80,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: context.colors.listTileBackground,
      border: Border.all(
        color: context.colors.text,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: colors.length + 1,
      itemBuilder: (_, index) {
        final color = colors.elementAtOrNull(index);

        ///
        /// COLOR
        ///
        if (color != null) {
          return CategoryColor(
            onPressed: () => onPressedColor(color),
            color: color.withValues(
              alpha: activeColor == color ? 1 : 0.4,
            ),
            highlightColor: color.withValues(
              alpha: activeColor == color ? 1 : 0.4,
            ),
          );
        }

        ///
        /// ADD NEW CATEGORY
        ///
        return CategoryColor(
          onPressed: onPressedAdd,
          color: context.colors.buttonBackground,
          highlightColor: context.colors.listTileBackground,
          icon: PhosphorIcons.plus,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(width: 12),
    ),
  );
}
