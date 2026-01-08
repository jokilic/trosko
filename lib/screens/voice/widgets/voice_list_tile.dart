import 'package:flutter/material.dart';

import '../../../theme/extensions.dart';

class VoiceListTile extends StatelessWidget {
  final String title;
  final Color? backgroundColor;

  const VoiceListTile({
    required this.title,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Material(
      color: backgroundColor ?? context.colors.listTileBackground,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
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
          child: Text(
            title,
            style: context.textStyles.homeTransactionTitle,
          ),
        ),
      ),
    ),
  );
}
