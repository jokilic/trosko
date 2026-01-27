import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../theme/colors.dart';
import '../../../theme/extensions.dart';
import '../../../util/color.dart';

class CategoryCustomColorModal extends StatefulWidget {
  final Color startingColor;

  const CategoryCustomColorModal({
    required this.startingColor,
    required super.key,
  });

  @override
  State<CategoryCustomColorModal> createState() => _CategoryCustomColorModalState();
}

class _CategoryCustomColorModalState extends State<CategoryCustomColorModal> {
  late var color = widget.startingColor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          /// TEXT
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              'settingsCustomColorModalText'.tr(),
              style: context.textStyles.homeTitle,
            ),
          ),
          const SizedBox(height: 12),

          ///
          /// COLOR
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: (newColor) => color = newColor,
              enableAlpha: false,
              hexInputBar: true,
              labelTypes: const [],
              pickerAreaBorderRadius: BorderRadius.circular(8),
              pickerAreaHeightPercent: 0.55,
            ),
          ),
          const SizedBox(height: 28),

          ///
          /// BUTTON
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop(color);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.buttonPrimary,
                  foregroundColor: getWhiteOrBlackColor(
                    backgroundColor: context.colors.buttonPrimary,
                    whiteColor: TroskoColors.lightThemeWhiteBackground,
                    blackColor: TroskoColors.lightThemeBlackText,
                  ),
                  overlayColor: context.colors.buttonBackground,
                  disabledBackgroundColor: context.colors.disabledBackground,
                  disabledForegroundColor: context.colors.disabledText,
                ),
                child: Text(
                  'settingsCustomColorModalButton'.tr().toUpperCase(),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
