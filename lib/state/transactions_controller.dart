import 'package:get/get.dart';
import 'package:money_app/extensions.dart';
import 'package:money_app/model.dart';

/// Seed state ///
const kInitialBalance = 1329.25;

List<PaymentTransaction> kSeedPayments() {
  final now = DateTime.now();

  return [
    PaymentTransaction(
        createdAt: now.offsetHours(-2), amount: 32.00, recipient: 'eBay'),
    PaymentTransaction(
        createdAt: now.offsetHours(-4),
        amount: 65.00,
        recipient: 'Merton Council'),
    PaymentTransaction(
        createdAt: now.oneDayBefore(), amount: 32.00, recipient: 'Amazon'),
    PaymentTransaction(
        createdAt: now.oneDayBefore(hourOffset: -4),
        amount: 1400.00,
        recipient: 'John Snow'),
  ];
}

List<TopupTransaction> kSeedTopups() {
  final now = DateTime.now();

  return [
    TopupTransaction(createdAt: now.offsetHours(-6), amount: 150.00),
    TopupTransaction(
      createdAt: now.oneDayBefore(hourOffset: -6),
      amount: 200.00,
    ),
  ];
}

/// Observable State ///
class TransactionsController extends GetxController {
  @override
  void onInit() {
    payments.addAll(kSeedPayments());
    topups.addAll(kSeedTopups());
    super.onInit();
  }

  final payments = <PaymentTransaction>[].obs;
  final topups = <TopupTransaction>[].obs;

  addPaymentTransaction({required double amount, required String recipient}) {
    payments.add(PaymentTransaction(
        createdAt: DateTime.now(), amount: amount, recipient: recipient));
    update();
  }

  addTopupTransaction({required double amount}) {
    topups.add(TopupTransaction(createdAt: DateTime.now(), amount: amount));
  }

  /// Utils ///
  RxDouble get calculateBalance => (kInitialBalance +
          topups.map((t) => t.amount).sum -
          payments.map((p) => p.amount).sum)
      .obs;
}
