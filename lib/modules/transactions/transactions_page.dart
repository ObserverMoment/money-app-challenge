import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:money_app/animation/custom_animated_list.dart';
import 'package:money_app/components/currency_display.dart';
import 'package:money_app/components/custom_app_bar.dart';
import 'package:money_app/constants.dart';
import 'package:money_app/extensions.dart';
import 'package:money_app/model.dart';
import 'package:money_app/modules/transactions/transactions_controller.dart';
import 'package:money_app/router.dart';

class TransactionsPage extends GetView<TransactionsController> {
  const TransactionsPage({super.key});

  double get _actionButtonsCardHeight => 120.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          extendedChild: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _BalanceDisplay(controller: controller),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: _actionButtonsCardHeight,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        context.theme.colorScheme.secondary,
                        context.theme.colorScheme.secondary,
                        context.theme.scaffoldBackgroundColor,
                        context.theme.scaffoldBackgroundColor
                      ],
                          stops: const [
                        0.0,
                        0.5,
                        0.5,
                        1.0
                      ])),
                ),
                Center(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: kMaxDisplayScreenWidth,
                          maxHeight: _actionButtonsCardHeight),
                      child: _PaymentActionButtons(_actionButtonsCardHeight)),
                ),
              ],
            ),
            Expanded(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: kMaxDisplayScreenWidth),
                child: const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: _TransactionsPageList(),
                ),
              ),
            ),
          ],
        ));
  }
}

class _BalanceDisplay extends StatelessWidget {
  final TransactionsController controller;
  const _BalanceDisplay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedCurrencyDisplay(
          amount: controller.calculateBalance.value,
          withCurrency: true,
          withSign: false,
          fontSizeLarge: 50,
          fontSizeSmall: 34,
          color: context.theme.colorScheme.onSecondary,
          fontWeight: FontWeight.bold,
        ));
  }
}

class _PaymentActionButtons extends StatelessWidget {
  final double height;
  const _PaymentActionButtons(this.height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
        elevation: 3,
        color: context.theme.cardColor,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ('payment_icon', 'Pay', () => Get.toNamed(PageRoutes.pay)),
                ('topup_icon', 'Top up', () => Get.toNamed(PageRoutes.topup)),
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
      ),
    );
  }
}

class _TransactionsPageList extends GetView<TransactionsController> {
  const _TransactionsPageList();

  @override
  Widget build(BuildContext context) {
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
          final payments = controller.payments;
          final topups = controller.topups;
          final transactionsPage = [...payments, ...topups]
              .sortedBy<DateTime>((t) => t.createdAt)
              .reversed;

          final transactionsPageByDay = transactionsPage
              .groupListsBy<DateTime>((t) => DateTime(t.createdAt.year,
                  t.createdAt.month, t.createdAt.month, t.createdAt.day))
              .values
              .toList();

          return Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: transactionsPageByDay.length,
                shrinkWrap: true,
                itemBuilder: (context, dayIndex) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 8),
                          child: Text(
                            transactionsPageByDay[dayIndex][0]
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
                          child: CustomAnimatedList<Transaction>(
                            items: transactionsPageByDay[dayIndex],
                            itemBuilder: (txn) => _TransactionDisplay(
                              transaction: txn,
                            ),
                            itemsAreTheSame: (a, b) =>
                                a.toString() == b.toString(),
                          ),
                        ).animate().fadeIn()
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
          TopupTransaction() => 'Top Up'
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
          CurrencyDisplay(
              amount: transaction.amount,
              withCurrency: false,
              withSign: transaction is TopupTransaction,
              fontSizeLarge: 18,
              fontSizeSmall: 16,
              color: transaction is TopupTransaction
                  ? context.theme.colorScheme.secondary
                  : null)
        ],
      ),
    );
  }
}
