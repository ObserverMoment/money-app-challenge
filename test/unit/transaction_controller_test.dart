import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/modules/transactions/transactions_controller.dart';

void main() {
  late TransactionsController controller;

  setUp(() {
    controller = TransactionsController();
  });

  tearDown(() {
    controller.dispose();
  });

  group('TransactionController', () {
    test('adding via addPaymentTransaction should add to state', () {
      final initialPaymentsCount = controller.payments.length;

      controller.addPaymentTransaction(
          amount: 99.99, recipient: 'Test Recipient');

      expect(controller.payments.length, initialPaymentsCount + 1);
    });

    test('adding via addTopupTransaction should add to state', () {
      final initialTopupsCount = controller.topups.length;
      controller.addTopupTransaction(amount: 99.99);

      expect(controller.topups.length, initialTopupsCount + 1);
    });
  });
}
