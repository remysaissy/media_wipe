import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container(
        color: Colors.white,
        child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CircleAvatar(radius: 56, //radius of avatar
                backgroundColor: Colors.white,
                child: Padding(padding: const EdgeInsets.all(8),
                  child: ClipOval(child: Image.asset('assets/icons/icon.png')),
                ),
              ),
              const CircularProgressIndicator(),
            ])
    ));
  }
}