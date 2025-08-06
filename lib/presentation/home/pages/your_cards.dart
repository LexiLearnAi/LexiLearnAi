import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexilearnai/presentation/home/widgets/app_bar/basic_app_bar.dart';
import 'package:lexilearnai/presentation/home/widgets/list_view/list_view_with_detail.dart';

@RoutePage()
class YourCardsScreen extends StatelessWidget {
  const YourCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: BasicAppBar(title: "Your Cards"), body: ListViewWithDetail());
  }
}
