import 'package:flutter/material.dart';

void ensureVisibleHorizontally({
  required GlobalKey? key,
  required ScrollController controller,
}) {
  final ctx = key?.currentContext;
  final renderObject = ctx?.findRenderObject();

  if (renderObject == null || !controller.hasClients) {
    return;
  }

  controller.position.ensureVisible(
    renderObject,
    alignment: 0.5,
  );
}
