import 'package:flutter/material.dart';

import '../../../models/category/category.dart';
import '../../../theme/extensions.dart';
import '../../../util/icons.dart';
import 'settings_category.dart';

class SettingsCategories extends StatelessWidget {
  final List<Category> categories;
  final void Function(List<Category> newOrder) onReorderCategories;

  const SettingsCategories({
    required this.categories,
    required this.onReorderCategories,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(
      height: 104,
      child: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        itemCount: categories.length,
        onReorder: (oldIndex, newIndex) {
          if (newIndex > categories.length) {
            newIndex = categories.length;
          }

          final list = List<Category>.from(categories);

          if (newIndex > oldIndex) {
            newIndex -= 1;
          }

          final item = list.removeAt(oldIndex);
          list.insert(newIndex, item);

          onReorderCategories(list);
        },
        proxyDecorator: (child, _, __) => Material(
          borderRadius: BorderRadius.circular(8),
          color: context.colors.listTileBackground,
          child: child,
        ),
        itemBuilder: (_, index) {
          final category = categories[index];

          return ReorderableDelayedDragStartListener(
            key: ValueKey(category.id),
            index: index,
            child: SettingsCategory(
              color: category.color,
              highlightColor: category.color,
              icon: getRegularIconFromName(category.iconName)?.value,
              text: category.name,
            ),
          );
        },
      ),
    ),
  );
}
