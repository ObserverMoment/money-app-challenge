import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class TransferAmountInput extends StatelessWidget {
  final String amount;
  final void Function(String v) updateAmount;
  const TransferAmountInput(
      {super.key, required this.amount, required this.updateAmount});

  List<String> get _customInputDisplayValues =>
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '<'];

  void _handleInput(String value) {
    if (value == '<') {
      _handleBackspace();
    } else if (value == '.') {
      _handleDot();
    } else {
      _handleInteger(value);
    }
  }

  void _handleBackspace() {
    if (amount.length == 1) {
      updateAmount('0');
    } else if (amount != '0') {
      final newString = amount.substring(0, amount.length - 1);
      updateAmount(newString);
    }
  }

  void _handleDot() {
    if (!amount.contains('.')) {
      final newString = '$amount.';
      updateAmount(newString);
    }
  }

  void _handleInteger(String value) {
    final intValue = int.tryParse(value);
    if (intValue == null || intValue < 0 || intValue > 9) {
      throw Exception('$value is not a valid integer input.');
    }

    /// Initial value is 0 but we do not want "0x"
    if (amount == '0') {
      updateAmount(value);
    } else {
      /// Check if user has already entered 2dp.
      if (amount.split('.').length > 1 && amount.split('.')[1].length >= 2) {
        /// Ignore? Shake?
        return;
      }
      final newString = '$amount$value';
      updateAmount(newString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.only(bottom: 48),
            alignment: Alignment.center,
            child: RichText(
                text: TextSpan(children: [
              const TextSpan(text: '£', style: TextStyle(fontSize: 24)),
              TextSpan(
                  text: amount,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
            ]))),
        GridView.count(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          childAspectRatio: 2,
          crossAxisCount: 3,
          children: _customInputDisplayValues
              .map((v) => InkWell(
                    onTap: () => _handleInput(v),
                    child: Center(
                        child: Text(
                      v,
                      style: TextStyle(
                          color: context.theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    )),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
