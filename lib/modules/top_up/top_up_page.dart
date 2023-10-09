import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_app/components/custom_app_bar.dart';
import 'package:money_app/components/primary_button.dart';
import 'package:money_app/components/transfer_amount_input.dart';
import 'package:money_app/components/transfer_confirmation_modal.dart';
import 'package:money_app/extensions.dart';
import 'package:money_app/modules/top_up/top_up_controller.dart';

class TopupPage extends GetView<TopupController> {
  const TopupPage({super.key});

  void _confirmTopup(
      {required BuildContext context,
      required VoidCallback onConfirm,
      required double amount}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (context) => TransferConfirmationDialog(
              title: 'Confirm Amount',
              message: 'You are about to topup',
              amount: amount,
              onConfirm: () {
                context.pop();
                onConfirm();
              },
              onCancel: context.pop,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.secondary,
      appBar: CustomAppBar(
        customActions: [
          IconButton(
              onPressed: context.pop,
              icon: Icon(
                Icons.cancel,
                color: context.theme.colorScheme.onSecondary,
              ))
        ],
        extendedChild: Center(
          child: Text(
            'How Much?',
            style: TextStyle(
                color: context.theme.colorScheme.onSecondary,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            return TransferAmountInput(
              amount: controller.amount.value,
              updateAmount: controller.updateAmount,
            );
          }),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => PrimaryButton(
                  label: 'Topup',
                  disabled: !controller.inputValid.value,
                  onPressed: () => _confirmTopup(
                      context: context,
                      amount: double.parse(controller.amount.value),
                      onConfirm: () {
                        controller.handleSubmit();
                        context.pop();
                      }),
                ),
              ))
        ],
      ),
    );
  }
}
