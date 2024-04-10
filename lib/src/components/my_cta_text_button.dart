import 'package:flutter/material.dart';

class MyCTATextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const MyCTATextButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}