import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_app/extensions.dart';
import 'package:money_app/main.dart';
import 'package:money_app/model.dart';
import 'package:money_app/pages/pay.dart';
import 'package:money_app/pages/top_up.dart';
import 'package:money_app/state/transactions_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  double get _overhang => 82.0;
  double get _extendedAppBarHeight => 200.0;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransactionsController>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(kAppBarTitle),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(_extendedAppBarHeight),
            child: SizedBox(
                height: _extendedAppBarHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(top: 30, child: _BalanceDisplay(controller: c)),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: -_overhang,
                        child: SizedBox(
                            height: _overhang * 2,
                            child: const _PaymentActionButtons())),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //       behavior: HitTestBehavior.translucent,
                    //       onTap: () => Get.to(() => const TopupPage()),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(2.0),
                    //         child: Image.asset(
                    //           'assets/icons/payment_icon.jpg',
                    //           height: 60,
                    //         ),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       behavior: HitTestBehavior.opaque,
                    //       onTap: () => Get.to(() => const TopupPage()),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(2.0),
                    //         child: Text(
                    //           'Test',
                    //           style:
                    //               const TextStyle(fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                )),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: _overhang),
          child: const _TransactionsList(),
        ));
  }
}

class _BalanceDisplay extends StatelessWidget {
  final TransactionsController controller;
  const _BalanceDisplay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.calculateBalance.value.currencyAmountDisplay(
        context: context,
        withSign: false,
        withCurrency: true,
        fontSize: 50,
        decimalsFontSize: 34,
        color: Colors.white));
  }
}

class _PaymentActionButtons extends StatelessWidget {
  const _PaymentActionButtons();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: context.theme.cardColor,
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ('payment_icon', 'Pay', () => Get.to(() => const PayPage())),
              ('topup_icon', 'Top up', () => Get.to(() => const TopupPage())),
            ]
                .map(
                  (d) => Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: d.$3,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                'assets/icons/${d.$1}.png',
                                height: 60,
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: d.$3,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                d.$2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }
}

class _TransactionsList extends StatelessWidget {
  const _TransactionsList();

  get itemBuilder => null;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransactionsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Recent Activity',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Obx(() {
          final payments = c.payments;
          final topups = c.topups;
          final transactions = [...payments, ...topups]
              .sortedBy<DateTime>((t) => t.createdAt)
              .reversed;

          final transactionsByDay = transactions
              .groupListsBy<DateTime>((t) => DateTime(t.createdAt.year,
                  t.createdAt.month, t.createdAt.month, t.createdAt.day))
              .values
              .toList();

          return Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: transactionsByDay.length,
                shrinkWrap: true,
                itemBuilder: (context, dayIndex) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TODO: Check for empty list if necessary.
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 8),
                          child: Text(
                            transactionsByDay[dayIndex][0]
                                .createdAt
                                .daysAgoOrDateDisplay
                                .toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: context.theme.primaryColor
                                    .withOpacity(0.5)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration:
                              BoxDecoration(color: context.theme.cardColor),
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: transactionsByDay[dayIndex].length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, txnIndex) =>
                                  _TransactionDisplay(
                                    transaction: transactionsByDay[dayIndex]
                                        [txnIndex],
                                  )),
                        )
                      ],
                    )),
          );
        })
      ],
    );
  }
}

class _TransactionDisplay extends StatelessWidget {
  final Transaction transaction;
  const _TransactionDisplay({required this.transaction});

  Widget _buildIcon(BuildContext context) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: context.theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(4)),
        child: Icon(
          switch (transaction) {
            PaymentTransaction() => Icons.add_circle,
            TopupTransaction() => Icons.shopping_bag,
          },
          color: context.theme.scaffoldBackgroundColor,
          size: 16,
        ),
      );

  Widget get _buildLabel => Text(
        switch (transaction) {
          PaymentTransaction() => (transaction as PaymentTransaction).recipient,
          TopupTransaction() => 'Topup'
        },
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildIcon(context),
              const SizedBox(width: 12),
              _buildLabel,
            ],
          ),
          transaction.amount.currencyAmountDisplay(
              context: context,
              withSign: transaction is TopupTransaction,
              fontSize: 18,
              withCurrency: false,
              decimalsFontSize: 16,
              color: transaction is TopupTransaction
                  ? context.theme.colorScheme.secondary
                  : null),
        ],
      ),
    );
  }
}
