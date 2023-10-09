import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/modules/top_up/top_up_controller.dart';
import 'package:money_app/modules/transactions/transactions_controller.dart';

void main() {
  late TransactionsController transactionsController;
  late TopupController topupController;

  setUp(() {
    transactionsController = TransactionsController();
    topupController = TopupController(transactionsController);
  });

  tearDown(() {
    transactionsController.dispose();
    topupController.dispose();
  });

  group('TopupController', () {
    test('updateAmount updates observable and checks input validity', () {
      expect(topupController.amount.value, '0');
      expect(topupController.inputValid.value, false);

      topupController.updateAmount('100');

      expect(topupController.amount.value, '100');
      expect(topupController.inputValid.value, true);
    });

    test('updateAmount throws exception when cannot parse input as double', () {
      expect(topupController.amount.value, '0');
      expect(topupController.inputValid.value, false);

      expect(() => topupController.updateAmount('10/u0'), throwsException);
    });

    test(
        'handleSubmit adds a TopupTransaction to transactionsController.topups and resets local state.',
        () {
      final initialCount = transactionsController.topups.length;

      topupController.handleSubmit();

      expect(transactionsController.topups.length, initialCount + 1);
      expect(topupController.amount.value, '0');
      expect(topupController.inputValid.value, false);
    });
  });
}
