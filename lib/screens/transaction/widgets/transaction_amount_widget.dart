import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../theme/theme.dart';
import '../../../util/currency.dart';
import 'transaction_amount_button.dart';

class TransactionAmountWidget extends StatefulWidget {
  final Function(int cents) onValueChanged;
  final int initialCents;

  const TransactionAmountWidget({
    required this.onValueChanged,
    required this.initialCents,
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

    /// Initialize with proper formatting from `initialCents`
    currentCents = widget.initialCents;
    currentValue = formatCentsToCurrency(currentCents);
  }

  @override
  void dispose() {
    holdTimer?.cancel();
    super.dispose();
  }

  /// Triggered when some button is pressed
  void onButtonPressed(String value) {
    HapticFeedback.lightImpact();

    setState(() {
      switch (value) {
        case 'backspace':
          backspacePressed();
          break;
        case '00':
          doubleZeroPressed();
          break;
        default:
          handleDigitInput(value);
      }

      /// Convert current display back to cents and notify parent
      currentCents = formatCurrencyToCents(currentValue);
      widget.onValueChanged(currentCents);
    });
  }

  /// Handless pressing regular numbers
  void handleDigitInput(String digit) {
    /// Convert current display to raw cents `String` for manipulation
    var rawValue = currentValue.trim().replaceAll(',', '').replaceAll('.', '').replaceAll(' ', '');

    /// If `000`, `00` or `0`, start fresh
    if (rawValue == '000' || rawValue == '00' || rawValue == '0' || rawValue.isEmpty) {
      rawValue = '';
    }

    /// Add the new digit
    rawValue += digit;

    /// Convert back to display format
    final cents = int.tryParse(rawValue) ?? 0;
    currentValue = formatCentsToCurrency(cents);
  }

  /// Multiply `currentCents` by 100 (add two zeros)
  void doubleZeroPressed() {
    currentCents = currentCents * 100;
    currentValue = formatCentsToCurrency(currentCents);
  }

  /// Triggered when the user presses `backspace` button
  void backspacePressed() {
    if (currentCents <= 0) {
      currentValue = '0,00';
      return;
    }

    /// Remove last digit by dividing by 10
    currentCents = currentCents ~/ 10;
    currentValue = formatCentsToCurrency(currentCents);
  }

  /// Triggered when the user holds `backspace` button
  void startHoldTimer() {
    holdTimer?.cancel();

    holdTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isHolding = true;
      });
      HapticFeedback.mediumImpact();
      clearAll();
    });
  }

  /// Triggered when the user stops holding `backspace` button
  void stopHoldTimer() {
    holdTimer?.cancel();

    setState(() {
      isHolding = false;
    });
  }

  /// Resets values to zero
  void clearAll() {
    setState(() {
      currentValue = '0,00';
      currentCents = 0;
    });

    widget.onValueChanged(currentCents);
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ///
      /// CURRENT VALUE
      ///
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
        decoration: BoxDecoration(
          color: context.colors.listTileBackground,
          border: Border.all(
            color: context.colors.text,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            PhosphorIcon(
              PhosphorIcons.currencyEur(
                PhosphorIconsStyle.bold,
              ),
              color: context.colors.text,
              size: 28,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                currentValue,
                style: context.textStyles.transactionAmountCurrentValue,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),

      ///
      /// NUMPAD
      ///
      GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2,
        ),
        itemCount: 12,
        itemBuilder: (_, index) {
          ///
          /// NUMBERS
          ///
          if (index < 9) {
            final number = (index + 1).toString();

            return TransactionAmountButton(
              onPressed: () => onButtonPressed(number),
              child: Text(
                number,
                style: context.textStyles.transactionAmountNumber,
              ),
            );
          }
          ///
          /// `00` BUTTON
          ///
          else if (index == 9) {
            return TransactionAmountButton(
              onPressed: () => onButtonPressed('00'),
              child: Text(
                '00',
                style: context.textStyles.transactionAmountNumber,
              ),
            );
          }
          ///
          /// ZERO BUTTON
          ///
          else if (index == 10) {
            return TransactionAmountButton(
              onPressed: () => onButtonPressed('0'),
              child: Text(
                '0',
                style: context.textStyles.transactionAmountNumber,
              ),
            );
          }
          ///
          /// BACKSPACE BUTTON
          ///
          else {
            return TransactionAmountButton(
              onPressed: () => onButtonPressed('backspace'),
              onLongPressStart: startHoldTimer,
              onLongPressEnd: stopHoldTimer,
              child: PhosphorIcon(
                PhosphorIcons.backspace(
                  PhosphorIconsStyle.bold,
                ),
                color: isHolding ? context.colors.delete : context.colors.text,
                size: 24,
              ),
            );
          }
        },
      ),
    ],
  );
}
