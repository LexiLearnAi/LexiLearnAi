import 'package:flutter/material.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';

/// Arama sonucu bulunamadığında gösterilen widget
class NoSearchResultState extends StatelessWidget {
  const NoSearchResultState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: AppColorScheme.lightColorScheme.primary,
          ),
          const SizedBox(height: 16),   
          const Text(
            'Arama sonucu bulunamadı',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
