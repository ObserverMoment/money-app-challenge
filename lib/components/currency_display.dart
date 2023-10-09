import 'package:flutter/material.dart';
import 'package:money_app/extensions.dart';

/// Styled and formatted currency display widget.
class CurrencyDisplay extends StatelessWidget {
  final double amount;
  final bool withCurrency;
  final bool withSign;
  final double fontSizeLarge;
  final double fontSizeSmall;
  final Color? color;
  final FontWeight fontWeight;
  const CurrencyDisplay({
    super.key,
    required this.amount,
    required this.withCurrency,
    required this.withSign,
    required this.fontSizeLarge,
    required this.fontSizeSmall,
    this.color,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    final preDecimal = amount.stringMyDouble().split(".")[0];
    final postDecimal = amount.stringMyDouble().split(".")[1];

    final subTextStyle = TextStyle(
      fontSize: fontSizeSmall,
    );
    return RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(
                fontWeight: fontWeight, fontSize: fontSizeLarge, color: color),
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

/// Styled and formatted currency display widget which will also animate on receiving a new [amount].
class AnimatedCurrencyDisplay extends StatefulWidget {
  final double amount;
  final bool withCurrency;
  final bool withSign;
  final double fontSizeLarge;
  final double fontSizeSmall;
  final Color? color;
  final FontWeight fontWeight;
  const AnimatedCurrencyDisplay({
    super.key,
    required this.amount,
    required this.withCurrency,
    required this.withSign,
    required this.fontSizeLarge,
    required this.fontSizeSmall,
    this.color,
    this.fontWeight = FontWeight.normal,
  });

  @override
  State<AnimatedCurrencyDisplay> createState() =>
      _AnimatedCurrencyDisplayState();
}

class _AnimatedCurrencyDisplayState extends State<AnimatedCurrencyDisplay>
    with SingleTickerProviderStateMixin {
  late double _amount;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Duration get _animationDuration => const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _amount = widget.amount;

    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedCurrencyDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount) {
      // Animate out
      _animationController.reverse().then((value) {
        // Update the value
        setState(() {
          _amount = widget.amount;
        });
        // Animate back in.
        _animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preDecimal = _amount.stringMyDouble().split(".")[0];
    final postDecimal = _amount.stringMyDouble().split(".")[1];

    final subTextStyle = TextStyle(
      fontSize: widget.fontSizeSmall,
    );
    return FadeTransition(
      opacity: _fadeAnimation,
      child: RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(
                  fontWeight: widget.fontWeight,
                  fontSize: widget.fontSizeLarge,
                  color: widget.color),
              children: [
            if (widget.withSign) const TextSpan(text: '+'),
            if (widget.withCurrency) TextSpan(text: '£', style: subTextStyle),
            TextSpan(
              text: preDecimal,
            ),
            const TextSpan(text: '.'),
            TextSpan(text: postDecimal, style: subTextStyle),
          ])),
    );
  }
}
