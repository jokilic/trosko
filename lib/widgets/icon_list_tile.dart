import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/extensions.dart';
import '../util/color.dart';

class IconListTile extends StatelessWidget {
  final bool isActive;
  final Function() onPressed;
  final MapEntry<String, PhosphorIconData> icon;

  const IconListTile({
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
              PhosphorIcon(
                icon.value,
                color: isActive
                    ? getWhiteOrBlackColor(
                        backgroundColor: context.colors.buttonPrimary,
                        whiteColor: TroskoColors.lightThemeWhiteBackground,
                        blackColor: TroskoColors.lightThemeBlackText,
                      )
                    : context.colors.text,
                size: 32,
              ),
              const SizedBox(width: 12),

              ///
              /// TITLE
              ///
              Expanded(
                child: Text(
                  icon.key,
                  style: context.textStyles.categoryIcon.copyWith(
                    color: isActive
                        ? getWhiteOrBlackColor(
                            backgroundColor: context.colors.buttonPrimary,
                            whiteColor: TroskoColors.lightThemeWhiteBackground,
                            blackColor: TroskoColors.lightThemeBlackText,
                          )
                        : null,
                  ),
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
