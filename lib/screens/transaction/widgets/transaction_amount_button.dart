import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/trosko_button.dart';

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
  Widget build(BuildContext context) => TroskoButton(
    onPressed: onPressed,
    onTapDown: onLongPressStart != null ? () => onLongPressStart!() : null,
    onTapUp: onLongPressEnd != null ? () => onLongPressEnd!() : null,
    onTapCancel: onLongPressEnd,
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.colors.background.withValues(alpha: 0.5),
      ),
      alignment: Alignment.center,
      child: child,
    ),
  );
}
