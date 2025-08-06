import 'package:flutter/material.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';

/// Hiç kart olmadığında gösterilen widget
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 48,
            color: AppColorScheme.lightColorScheme.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz kart eklenmemiş',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () async {
              // Bottom sheet'i açmak için gerekli işlem
            },
            icon: const Icon(Icons.add),
            label: const Text('Kart Ekle'),
          ),
        ],
      ),
    );
  }
}
