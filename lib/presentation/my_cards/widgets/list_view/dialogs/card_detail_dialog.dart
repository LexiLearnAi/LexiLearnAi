import 'package:flutter/material.dart';
import 'package:lexilearnai/common/widgets/flip_card/app_flip_card.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';

/// Kart detay dialogunu gösteren widget
class CardDetailDialog extends StatelessWidget {
  final CardEntity card;

  const CardDetailDialog({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: AppFlipCard(
        card: card,
      ),
    );
  }
}
