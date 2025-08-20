import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TroskoTextField extends StatelessWidget {
  final bool autofocus;
  final TextEditingController controller;
  final Color fillColor;
  final String labelText;
  final TextInputType keyboardType;
  final int? minLines;
  final int? maxLines;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;

  const TroskoTextField({
    required this.autofocus,
    required this.controller,
    required this.fillColor,
    required this.labelText,
    required this.keyboardType,
    required this.textAlign,
    required this.textCapitalization,
    required this.textInputAction,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) => TextField(
    autofocus: autofocus,
    controller: controller,
    cursorHeight: 24,
    cursorRadius: const Radius.circular(24),
    cursorWidth: 2.5,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: context.colors.text,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: context.colors.text,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      fillColor: fillColor.withValues(alpha: 0.25),
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: context.colors.text,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      labelText: labelText,
      labelStyle: context.textStyles.transactionNameTextField,
    ),
    keyboardType: keyboardType,
    minLines: minLines,
    maxLines: maxLines,
    style: context.textStyles.transactionNameTextField,
    textAlign: textAlign,
    textCapitalization: textCapitalization,
    textInputAction: textInputAction,
  );
}
