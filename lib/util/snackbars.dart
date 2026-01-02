import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/extensions.dart';

void showSnackbar(
  BuildContext context, {
  required String text,
  required IconData icon,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 1,
      content: Row(
        children: [
          PhosphorIcon(
            icon,
            color: context.colors.text,
            duotoneSecondaryColor: context.colors.buttonPrimary,
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: context.textStyles.homeTitle,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      behavior: SnackBarBehavior.floating,
      backgroundColor: context.colors.listTileBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: context.colors.text,
          width: 1.5,
        ),
      ),
    ),
  );
}
