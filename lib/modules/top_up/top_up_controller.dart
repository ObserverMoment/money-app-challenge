import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:money_app/modules/transactions/transactions_controller.dart';

/// Binding to View ///
class TopupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopupController(Get.find<TransactionsController>()));
  }
}

/// Observable State Controller ///
class TopupController extends GetxController {
  final TransactionsController transactionsController;

  TopupController(this.transactionsController);

  var amount = '0'.obs;
  var inputValid = false.obs;

  void updateAmount(String a) {
    if (double.tryParse(a) == null) {
      throw Exception('Unable to parse updated amount $a as a double.');
    }
    amount.value = a;
    inputValid.value = double.parse(a) > 0;
  }

  void handleSubmit() {
    transactionsController.addTopupTransaction(
        amount: double.parse(amount.value));
  }
}
