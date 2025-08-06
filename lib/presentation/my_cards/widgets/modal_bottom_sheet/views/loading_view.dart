import 'package:flutter/material.dart';
import 'package:lexilearnai/core/config/assets/app_animations.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(AppAnimations.loading),
      ],
    );
  }
}
