import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: Image.asset('assets/icons/icon.png'),
                    ),
                  ),
                ),
                const CircularProgressIndicator.adaptive(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
