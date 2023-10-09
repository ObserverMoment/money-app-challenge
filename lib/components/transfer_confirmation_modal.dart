import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:money_app/components/currency_display.dart';
import 'package:money_app/components/primary_button.dart';

class TransferConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final double amount;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  const TransferConfirmationDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.onConfirm,
      this.onCancel,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(6)),
        height: 310,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
                CurrencyDisplay(
                    amount: amount,
                    withCurrency: true,
                    withSign: false,
                    fontSizeLarge: 30,
                    fontSizeSmall: 24)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryButton(
                  label: 'Confirm',
                  onPressed: onConfirm,
                  backgroundColor: context.theme.colorScheme.secondary,
                ),
                if (onCancel != null)
                  TextButton(onPressed: onCancel, child: const Text('Cancel'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
