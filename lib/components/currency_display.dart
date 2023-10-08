import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_app/extensions.dart';

class CurrencyDisplay extends StatelessWidget {
  final double amount;
  final bool withCurrency;
  final bool withSign;
  final double fontSizeLarge;
  final double fontSizeSmall;
  final Color? color;
  const CurrencyDisplay(
      {super.key,
      required this.amount,
      required this.withCurrency,
      required this.withSign,
      required this.fontSizeLarge,
      required this.fontSizeSmall,
      this.color});

  @override
  Widget build(BuildContext context) {
    final preDecimal = amount.stringMyDouble().split(".")[0];
    final postDecimal = amount.stringMyDouble().split(".")[1];

    final subTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: fontSizeSmall,
    );
    return RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: fontSizeLarge,
                color: color ?? context.theme.colorScheme.onSecondary),
            children: [
          if (withSign) const TextSpan(text: '+'),
          if (withCurrency) TextSpan(text: '£', style: subTextStyle),
          TextSpan(
            text: preDecimal,
          ),
          const TextSpan(text: '.'),
          TextSpan(text: postDecimal, style: subTextStyle),
        ]));
  }
}
