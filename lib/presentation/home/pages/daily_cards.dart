import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexilearnai/presentation/home/widgets/app_bar/basic_app_bar.dart';

@RoutePage()
class DailyCardsScreen extends StatelessWidget {
  const DailyCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BasicAppBar(title: "Daily Cards"),
      body: Center(
        child: Text('Daily Cards'),
      ),
    );
  }
}
