import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  void _go(BuildContext context, String location) {
    Future.delayed(const Duration(milliseconds: 10), () {
      context.go(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOnboarded = context.select<SettingsModel, bool>((value) => value.isOnboarded);
    if (isOnboarded) {
      _go(context, '/home');
    } else {
      _go(context, '/onboarding');
    }
    return Provider.value(value: isOnboarded,
        child: Container(
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