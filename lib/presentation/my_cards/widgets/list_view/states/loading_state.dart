import 'package:flutter/material.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/common/shimmer_card_item.dart';

/// Kartların yüklenme durumunu gösteren widget
class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) => const ShimmerCardItem(),
    );
  }
}
