import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/modules/pay/pay_controller.dart';
import 'package:money_app/modules/transactions/transactions_controller.dart';

void main() {
  late TransactionsController transactionsController;
  late PayController payController;

  setUp(() {
    transactionsController = TransactionsController();
    payController = PayController(transactionsController);
    payController.onInit(); // Sets up the text editing controller listener.
  });

  tearDown(() {
    transactionsController.dispose();
    payController.dispose();
  });

  group('PayController', () {
    test('updateAmount updates observable and checks input validity', () {
      expect(payController.amount.value, '0');
      expect(payController.amountInputValid.value, false);

      payController.updateAmount('100');

      expect(payController.amount.value, '100');
      expect(payController.amountInputValid.value, true);
    });

    test('updateAmount throws exception when cannot parse input as double', () {
      expect(payController.amount.value, '0');
      expect(payController.amountInputValid.value, false);

      expect(() => payController.updateAmount('10/u0'), throwsException);
    });

    test(
        'recipientInputController.listener correctly updates receipient observable',
        () {
      const testRecipient = 'Test Recipient';
      expect(payController.recipient.value, '');
      expect(payController.receipientInputValid.value, false);

      payController.receipientInputController.text = testRecipient;

      expect(payController.recipient.value, testRecipient);
      expect(payController.receipientInputValid.value, true);
    });

    test(
        'handleSubmit adds a PaymentTransaction to transactionsController.payments and resets local state',
        () {
      final initialCount = transactionsController.payments.length;

      payController.handleSubmit();

      expect(transactionsController.payments.length, initialCount + 1);
      expect(payController.amount.value, '0');
      expect(payController.recipient.value, '');
      expect(payController.receipientInputValid.value, false);
      expect(payController.amountInputValid.value, false);
    });
  });
}
