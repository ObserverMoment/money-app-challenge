import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:money_app/modules/transactions/transactions_controller.dart';

/// Binding to View ///
class PayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PayController(Get.find<TransactionsController>()));
  }
}

enum PayProcessStep {
  amount(0),
  recipient(1);

  const PayProcessStep(this.value);
  final int value;
}

/// Observable State Controller ///
class PayController extends GetxController {
  final TransactionsController transactionsController;

  PayController(this.transactionsController);

  final pageController = PageController();
  final receipientInputController = TextEditingController();
  final receipientInputFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    receipientInputController.addListener(() {
      recipient.value = receipientInputController.text;
      receipientInputValid.value = recipient.value.isNotEmpty;
    });
  }

  var currentStep = PayProcessStep.amount.obs;
  var recipient = ''.obs;
  var amount = '0'.obs;
  var amountInputValid = false.obs;
  var receipientInputValid = false.obs;

  void gotoStep(PayProcessStep step) {
    pageController.animateToPage(step.value,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    currentStep.value = step;
    if (step == PayProcessStep.recipient) {
      // Delay to allow page view to animate into place, avoid renderflex error.
      Future.delayed(const Duration(milliseconds: 500),
          receipientInputFocusNode.requestFocus);
    }
  }

  void updateAmount(String a) {
    if (double.tryParse(a) == null) {
      throw Exception('Unable to parse updated amount $a as a double.');
    }
    amount.value = a;
    amountInputValid.value = double.parse(a) > 0;
  }

  void handleSubmit() {
    transactionsController.addPaymentTransaction(
        recipient: recipient.value, amount: double.parse(amount.value));
  }
}
