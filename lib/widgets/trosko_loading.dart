// ignore_for_file: prefer_int_literals

import 'dart:math';

import 'package:flutter/material.dart';

class TroskoLoading extends StatefulWidget {
  final Color color;
  final double size;
  final double lineWidth;
  final Duration duration;
  final AnimationController? controller;

  const TroskoLoading({
    required this.color,
    this.lineWidth = 8.0,
    this.size = 40.0,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  });

  @override
  State<TroskoLoading> createState() => _TroskoLoadingState();
}

class _TroskoLoadingState extends State<TroskoLoading> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;

  @override
  void initState() {
    super.initState();

    controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..repeat();
    animation1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0),
      ),
    );
    animation2 = Tween(begin: -2 / 3, end: 1 / 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0),
      ),
    );
    animation3 = Tween(begin: 0.25, end: 5 / 6).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: TroskoLoadingCurve(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Transform(
    transform: Matrix4.identity()..rotateZ((animation1.value) * 5 * pi / 6),
    alignment: FractionalOffset.center,
    child: SizedBox.fromSize(
      size: Size.square(widget.size),
      child: CustomPaint(
        foregroundPainter: RingPainter(
          paintWidth: widget.lineWidth,
          trackColor: widget.color,
          progressPercent: animation3.value,
          startAngle: pi * animation2.value,
        ),
      ),
    ),
  );
}

class RingPainter extends CustomPainter {
  RingPainter({
    required this.paintWidth,
    required this.trackColor,
    this.progressPercent,
    this.startAngle,
  }) : trackPaint = Paint()
         ..color = trackColor
         ..style = PaintingStyle.stroke
         ..strokeWidth = paintWidth
         ..strokeCap = StrokeCap.square;

  final double paintWidth;
  final Paint trackPaint;
  final Color trackColor;
  final double? progressPercent;
  final double? startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - paintWidth) / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle!,
      2 * pi * progressPercent!,
      false,
      trackPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TroskoLoadingCurve extends Curve {
  const TroskoLoadingCurve();

  @override
  double transform(double t) => (t <= 0.5) ? 2 * t : 2 * (1 - t);
}
