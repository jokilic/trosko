import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../util/currency.dart';

class TransactionAmountWidget extends StatefulWidget {
  final Function(int valueCents) onValueChanged;
  final int initialCents;
  final Color? primaryColor;
  final Color? backgroundColor;

  const TransactionAmountWidget({
    required this.onValueChanged,
    this.initialCents = 0,
    this.primaryColor,
    this.backgroundColor,
  });

  @override
  State<TransactionAmountWidget> createState() => _TransactionAmountWidgetState();
}

class _TransactionAmountWidgetState extends State<TransactionAmountWidget> {
  late String currentValue;
  late int currentCents;

  Timer? holdTimer;
  var isHolding = false;

  @override
  void initState() {
    super.initState();
    // Initialize with proper formatting from initialCents
    currentCents = widget.initialCents;
    currentValue = _formatCentsToDisplay(currentCents);
  }

  @override
  void dispose() {
    holdTimer?.cancel();
    super.dispose();
  }

  // Convert cents to display format using the existing formatCurrency function
  String _formatCentsToDisplay(int cents) {
    return formatCurrency(cents);
  }

  // Convert display format back to cents (e.g., "1,23" -> 123 cents)
  int _parseDisplayToCents(String display) {
    // Remove any spaces and replace comma with dot for parsing
    String normalized = display.trim().replaceAll('.', '').replaceAll(',', '');
    return int.tryParse(normalized) ?? 0;
  }

  void _onButtonPressed(String value) {
    HapticFeedback.lightImpact();

    setState(() {
      if (value == 'backspace') {
        _handleBackspace();
      } else if (value == ',00') {
        _handleQuickFill();
      } else {
        _handleDigitInput(value);
      }

      // Convert current display back to cents and notify parent
      currentCents = _parseDisplayToCents(currentValue);
      widget.onValueChanged(currentCents);
    });
  }

  void _handleDigitInput(String digit) {
    // Convert current display to raw cents string for manipulation
    String rawValue = currentValue.trim().replaceAll(',', '').replaceAll('.', '').replaceAll(' ', '');

    // If "000", "00", "0", start fresh
    if (rawValue == '000' || rawValue == '00' || rawValue == '0' || rawValue.isEmpty) {
      rawValue = '';
    }

    // Add the new digit
    rawValue += digit;

    // Convert back to display format using formatCurrency
    int cents = int.tryParse(rawValue) ?? 0;
    currentValue = formatCurrency(cents);
  }

  void _handleBackspace() {
    if (currentCents <= 0) {
      currentValue = '0,00';
      return;
    }

    // Remove last digit by dividing by 10
    currentCents = currentCents ~/ 10;
    currentValue = _formatCentsToDisplay(currentCents);
  }

  void _handleQuickFill() {
    // Quick fill multiplies current cents by 100 (adds two zeros)
    currentCents = currentCents * 100;
    currentValue = _formatCentsToDisplay(currentCents);
  }

  String _addThousandsSeparators(String number) {
    if (number.length <= 3) return number;

    var result = '';
    var count = 0;

    for (var i = number.length - 1; i >= 0; i--) {
      if (count == 3) {
        result = '.$result';
        count = 0;
      }
      result = number[i] + result;
      count++;
    }

    return result;
  }

  void _startHoldTimer() {
    holdTimer?.cancel();
    holdTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isHolding = true;
      });
      HapticFeedback.mediumImpact();
      _clearAll();
    });
  }

  void _stopHoldTimer() {
    holdTimer?.cancel();
    setState(() {
      isHolding = false;
    });
  }

  void _clearAll() {
    setState(() {
      currentValue = '0,00';
      currentCents = 0;
    });
    widget.onValueChanged(currentCents);
    HapticFeedback.heavyImpact();
  }

  Widget _buildNumButton(String number) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _onButtonPressed(number),
        splashColor: (widget.primaryColor ?? Theme.of(context).colorScheme.primary).withOpacity(0.2),
        highlightColor: (widget.primaryColor ?? Theme.of(context).colorScheme.primary).withOpacity(0.1),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: Text(
            number,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.primaryColor ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildActionButton({
    required String key,
    required Widget child,
    required VoidCallback onTap,
    VoidCallback? onLongPressStart,
    VoidCallback? onLongPressEnd,
    Color? backgroundColor,
  }) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: backgroundColor ?? (widget.primaryColor ?? Theme.of(context).colorScheme.primary).withOpacity(0.1),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        onTapDown: onLongPressStart != null ? (_) => onLongPressStart() : null,
        onTapUp: onLongPressEnd != null ? (_) => onLongPressEnd() : null,
        onTapCancel: onLongPressEnd,
        splashColor: (widget.primaryColor ?? Theme.of(context).colorScheme.primary).withOpacity(0.2),
        highlightColor: (widget.primaryColor ?? Theme.of(context).colorScheme.primary).withOpacity(0.1),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
          blurRadius: 16,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 24),

        // Current value display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            currentValue,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: widget.primaryColor ?? Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.right,
          ),
        ),

        const SizedBox(height: 24),

        // Numpad grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            if (index < 9) {
              // Numbers 1-9
              final number = (index + 1).toString();
              return _buildNumButton(number);
            } else if (index == 9) {
              // ,00 button
              return _buildActionButton(
                key: ',00',
                child: Text(
                  ',00',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: widget.primaryColor ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () => _onButtonPressed(',00'),
              );
            } else if (index == 10) {
              // 0 button
              return _buildNumButton('0');
            } else {
              // Backspace button
              return _buildActionButton(
                key: 'backspace',
                backgroundColor: isHolding ? Theme.of(context).colorScheme.error.withOpacity(0.2) : null,
                child: Icon(
                  Icons.backspace_outlined,
                  color: isHolding ? Theme.of(context).colorScheme.error : (widget.primaryColor ?? Theme.of(context).colorScheme.primary),
                  size: 24,
                ),
                onTap: () => _onButtonPressed('backspace'),
                onLongPressStart: _startHoldTimer,
                onLongPressEnd: _stopHoldTimer,
              );
            }
          },
        ),

        // Bottom padding for safe area
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    ),
  );
}
