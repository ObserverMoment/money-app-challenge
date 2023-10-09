import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool disabled;
  final Color? backgroundColor;

  const PrimaryButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.disabled = false,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: disabled ? 0.3 : 1,
      child: TextButton(
        onPressed: disabled ? null : onPressed,
        style: TextButton.styleFrom(
          fixedSize: const Size(180, 38),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: backgroundColor ??
              context.theme.colorScheme.onSecondary.withOpacity(0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onSecondary),
        ),
      ),
    );
  }
}
