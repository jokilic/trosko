import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class TransactionAmountButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final Function()? onLongPressStart;
  final Function()? onLongPressEnd;

  const TransactionAmountButton({
    required this.child,
    required this.onPressed,
    this.onLongPressStart,
    this.onLongPressEnd,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.listTileBackground,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onPressed,
      onTapDown: onLongPressStart != null ? (_) => onLongPressStart!() : null,
      onTapUp: onLongPressEnd != null ? (_) => onLongPressEnd!() : null,
      onTapCancel: onLongPressEnd,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colors.text,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    ),
  );
}
