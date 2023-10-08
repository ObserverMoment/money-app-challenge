import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_app/components/currency_display.dart';
import 'package:money_app/components/custom_app_bar.dart';
import 'package:money_app/components/primary_button.dart';
import 'package:money_app/extensions.dart';
import 'package:money_app/modules/top_up/top_up_controller.dart';

class TopupPage extends GetView<TopupController> {
  const TopupPage({super.key});

  List<String> get _customInputDisplayValues =>
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '<'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.secondary,
      appBar: CustomAppBar(
        customActions: [
          IconButton(
              onPressed: context.pop,
              icon: Icon(
                Icons.cancel,
                color: context.theme.colorScheme.onSecondary,
              ))
        ],
        extendedChild: Center(
          child: Text(
            'How Much?',
            style: TextStyle(
                color: context.theme.colorScheme.onSecondary,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Obx(() => RichText(
                      text: TextSpan(children: [
                    TextSpan(text: '£', style: TextStyle(fontSize: 24)),
                    TextSpan(
                        text: controller.amount.value,
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  ])))),
          GridView.count(
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            childAspectRatio: 2,
            crossAxisCount: 3,
            children: _customInputDisplayValues
                .map((v) => InkWell(
                      onTap: () => controller.handleInput(v),
                      child: Center(
                          child: Text(
                        v,
                        style: TextStyle(
                            color: context.theme.colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                    ))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              label: 'Topup',
              onPressed: () => print('topup'),
            ),
          )
        ],
      ),
    );
  }
}
