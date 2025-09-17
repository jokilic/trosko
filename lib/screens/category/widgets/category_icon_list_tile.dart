import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../theme/theme.dart';

class CategoryIconListTile extends StatelessWidget {
  final bool isActive;
  final Function() onPressed;
  final MapEntry<String, PhosphorIconData> icon;

  const CategoryIconListTile({
    required this.isActive,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Material(
      color: isActive ? context.colors.buttonPrimary : context.colors.listTileBackground,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        highlightColor: context.colors.buttonBackground,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 18,
          ),
          child: Row(
            children: [
              ///
              /// LEADING
              ///
              Icon(
                icon.value,
                color: context.colors.text,
                size: 32,
              ),
              const SizedBox(width: 12),

              ///
              /// TITLE
              ///
              Expanded(
                child: Text(
                  icon.key,
                  style: context.textStyles.categoryIcon,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
