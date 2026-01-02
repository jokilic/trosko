import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/extensions.dart';
import '../util/color.dart';
import '../util/icons.dart';

class IconListTile extends StatelessWidget {
  final bool isActive;
  final Function() onPressed;
  final MapEntry<String, PhosphorIconData Function([PhosphorIconsStyle])> icon;
  final bool useColorfulIcons;

  const IconListTile({
    required this.isActive,
    required this.onPressed,
    required this.icon,
    required this.useColorfulIcons,
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
                getPhosphorIcon(
                  icon.value,
                  isDuotone: useColorfulIcons,
                  isBold: false,
                ),
                color: isActive
                    ? getWhiteOrBlackColor(
                        backgroundColor: context.colors.buttonPrimary,
                        whiteColor: TroskoColors.lightThemeWhiteBackground,
                        blackColor: TroskoColors.lightThemeBlackText,
                      )
                    : context.colors.text,
                duotoneSecondaryColor: context.colors.buttonPrimary,
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
