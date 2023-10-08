import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_app/extensions.dart';
import 'package:money_app/main.dart';

class PayPage extends StatelessWidget {
  const PayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.secondary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(kAppBarTitle),
        actions: [
          IconButton(
              onPressed: context.pop,
              icon: Icon(
                Icons.cancel,
                color: context.theme.colorScheme.onSecondary,
              ))
        ],
      ),
    );
  }
}
