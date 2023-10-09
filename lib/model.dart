sealed class Transaction {
  final DateTime createdAt;
  final double amount;
  const Transaction(this.createdAt, this.amount);

  @override
  String toString() {
    return '$runtimeType-${createdAt.millisecondsSinceEpoch}-$amount';
  }
}

class PaymentTransaction extends Transaction {
  final String recipient;
  const PaymentTransaction(
      {required DateTime createdAt,
      required double amount,
      required this.recipient})
      : super(createdAt, amount);
}

class TopupTransaction extends Transaction {
  const TopupTransaction({required DateTime createdAt, required double amount})
      : super(createdAt, amount);
}
