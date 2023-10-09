import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_app/components/custom_app_bar.dart';
import 'package:money_app/components/primary_button.dart';
import 'package:money_app/components/transfer_amount_input.dart';
import 'package:money_app/components/transfer_confirmation_modal.dart';
import 'package:money_app/extensions.dart';
import 'package:money_app/modules/pay/pay_controller.dart';

class PayPage extends GetView<PayController> {
  const PayPage({super.key});

  Duration get _animationDuration => const Duration(milliseconds: 500);

  void _confirmPayment(
      {required BuildContext context,
      required VoidCallback onConfirm,
      required VoidCallback onCancel,
      required double amount,
      required String recipient}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (context) => TransferConfirmationDialog(
              title: 'Confirm Payment',
              message: 'Sending payment to "$recipient"',
              amount: amount,
              onConfirm: () {
                context.pop();
                onConfirm();
              },
              onCancel: () {
                onCancel();
                context.pop();
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final headingTextStyle = TextStyle(
        color: context.theme.colorScheme.onSecondary,
        fontSize: 26,
        fontWeight: FontWeight.bold);
    final textColor = context.theme.colorScheme.onSecondary;
    final textFieldBorder = UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: textColor));
    final screenWidth = MediaQuery.of(context).size.width;

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
            child: Obx(() => AnimatedSwitcher(
                  duration: _animationDuration,
                  child: controller.currentStep.value == PayProcessStep.amount
                      ? Text('How Much?', style: headingTextStyle)
                      : Text('To Who?', style: headingTextStyle),
                ))),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: PageView(
              controller: controller.pageController,
              children: [
                SizedBox(
                  height: 380,
                  child: Obx(
                    () => TransferAmountInput(
                      amount: controller.amount.value,
                      updateAmount: controller.updateAmount,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal:
                            screenWidth > 1000 ? screenWidth * 0.25 : 32),
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        cursorColor: context.theme.colorScheme.onSecondary,
                        controller: controller.receipientInputController,
                        focusNode: controller.receipientInputFocusNode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: textFieldBorder,
                          enabledBorder: textFieldBorder,
                          border: textFieldBorder,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(32.0),
              child: Obx(() => AnimatedSwitcher(
                    duration: _animationDuration,
                    child: controller.currentStep.value == PayProcessStep.amount
                        ? PrimaryButton(
                            label: 'Next',
                            disabled: !controller.amountInputValid.value,
                            onPressed: () =>
                                controller.gotoStep(PayProcessStep.recipient),
                          )
                        : PrimaryButton(
                            label: 'Pay',
                            disabled: !controller.receipientInputValid.value,
                            onPressed: () {
                              controller.receipientInputFocusNode.unfocus();
                              _confirmPayment(
                                  context: context,
                                  amount: double.parse(controller.amount.value),
                                  recipient: controller.recipient.value,
                                  onCancel: controller
                                      .receipientInputFocusNode.requestFocus,
                                  onConfirm: () {
                                    controller.handleSubmit();
                                    // Using named navigation to transactions page seems to cause loss of state and that page to re-render fully.
                                    Get.back();
                                  });
                            },
                          ),
                  ))),
        ],
      ),
    );
  }
}
