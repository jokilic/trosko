import 'package:flutter/material.dart';

import '../../../theme/extensions.dart';

class SettingsListTile extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final String subtitle;
  final Widget trailingWidget;

  const SettingsListTile({
    required this.onPressed,
    required this.title,
    required this.subtitle,
    required this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Material(
      color: onPressed != null ? context.colors.listTileBackground : context.colors.disabledBackground,
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
            horizontal: 20,
            vertical: 14,
          ),
          child: Row(
            children: [
              ///
              /// TITLE & SUBTITLE
              ///
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),

                    ///
                    /// TITLE
                    ///
                    Text(
                      title,
                      style: context.textStyles.homeTransactionTitle,
                    ),
                    const SizedBox(height: 4),

                    ///
                    /// SUBTITLE
                    ///
                    Text(
                      subtitle,
                      style: context.textStyles.homeTransactionNote,
                    ),
                  ],
                ),
              ),

              ///
              /// TRAILING
              ///
              const SizedBox(width: 12),
              trailingWidget,
            ],
          ),
        ),
      ),
    ),
  );
}
