import 'package:flutter/material.dart';
import 'package:money_app/main.dart';

class CustomAppBar extends AppBar {
  final double extendedHeight;
  final Widget extendedChild;

  final List<Widget>? customActions;
  CustomAppBar({
    super.key,
    this.extendedHeight = 110.0,
    required this.extendedChild,
    this.customActions,
  }) : super(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(kAppBarTitle),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(extendedHeight),
              child: SizedBox(height: extendedHeight, child: extendedChild),
            ),
            actions: customActions);
}
