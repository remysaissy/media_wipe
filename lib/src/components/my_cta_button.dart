
import 'package:flutter/material.dart';

class MyCTAButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;

  const MyCTAButton({super.key, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}