import 'package:flutter/material.dart';

import '../constants/durations.dart';

class TroskoButton extends StatefulWidget {
  final Widget child;
  final Function()? onPressed;
  final Function()? onLongPressed;
  final Function()? onTapDown;
  final Function()? onTapUp;
  final Function()? onTapCancel;

  const TroskoButton({
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    super.key,
  });

  @override
  State<TroskoButton> createState() => _TroskoButtonState();
}

class _TroskoButtonState extends State<TroskoButton> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: TroskoDurations.buttonAnimation,
    );

    animation = Tween<double>(begin: 1, end: 0.95).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onTapDown(TapDownDetails details) {
    controller.forward();

    if (widget.onTapDown != null) {
      widget.onTapDown!();
    }
  }

  void onTapUp(TapUpDetails details) {
    controller
      ..forward()
      ..reverse();

    if (widget.onPressed != null) {
      widget.onPressed!();
    }

    if (widget.onTapUp != null) {
      widget.onTapUp!();
    }
  }

  void onTapCancel() {
    controller.reverse();

    if (widget.onTapCancel != null) {
      widget.onTapCancel!();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: widget.onPressed != null || widget.onLongPressed != null || widget.onTapDown != null ? onTapDown : null,
    onTapUp: widget.onPressed != null || widget.onLongPressed != null || widget.onTapUp != null ? onTapUp : null,
    onTapCancel: widget.onPressed != null || widget.onLongPressed != null || widget.onTapCancel != null ? onTapCancel : null,
    onLongPress: widget.onLongPressed,
    child: AnimatedBuilder(
      animation: animation,
      builder: (_, child) => Transform.scale(
        scale: animation.value,
        child: child,
      ),
      child: widget.child,
    ),
  );
}
