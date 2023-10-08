import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

/// Binding to View ///
class TopupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopupController());
  }
}

/// Observable State Controller ///
class TopupController extends GetxController {
  var amount = '0'.obs;

  void updateAmount(String a) => amount.value = a;

  void handleInput(String value) {
    final a = amount.value;
    if (value == '<') {
      if (a.isNotEmpty && amount.value != '0') {
        final newString = a.substring(0, a.length - 1);
        updateAmount(newString);
      }
    } else if (value == '.' && !a.contains('.')) {
      updateAmount('$a.');
    } else {
      final intValue = int.tryParse(value);
      if (intValue == null || intValue < 0 || intValue > 9) {
        throw Exception('$value is not a valid input.');
      }

      /// TODO. If already contains a dot, add the new value and move the dot to the right to ensure only 2dp.
      if (a == '0') {
        updateAmount(value);
      } else {
        updateAmount('$a$value');
      }
    }
  }
}
