import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TroskoTextField extends StatelessWidget {
  final bool autofocus;
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final int? minLines;
  final int? maxLines;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Function(String value)? onSubmitted;

  const TroskoTextField({
    required this.autofocus,
    required this.controller,
    required this.labelText,
    required this.keyboardType,
    required this.textAlign,
    required this.textCapitalization,
    required this.textInputAction,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) => TextField(
    onSubmitted: onSubmitted,
    obscureText: obscureText,
    autofocus: autofocus,
    controller: controller,
    cursorHeight: 24,
    cursorRadius: const Radius.circular(8),
    cursorWidth: 1.5,
    cursorColor: context.colors.text,
    decoration: InputDecoration(
      filled: true,
      fillColor: context.colors.listTileBackground,
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: context.colors.text,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: context.colors.text,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: context.colors.text,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      labelText: labelText,
      labelStyle: context.textStyles.textField,
    ),
    keyboardType: keyboardType,
    minLines: minLines,
    maxLines: maxLines,
    style: context.textStyles.textField,
    textAlign: textAlign,
    textCapitalization: textCapitalization,
    textInputAction: textInputAction,
  );
}
