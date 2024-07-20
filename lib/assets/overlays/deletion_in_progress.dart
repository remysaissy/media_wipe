import 'package:flutter/material.dart';

class DeletionInProgress extends StatelessWidget {
  static OverlayEntry getOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return const DeletionInProgress();
      },
    );
  }

  const DeletionInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: false,
          child: Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}
