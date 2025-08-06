import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';
import 'package:lexilearnai/presentation/my_cards/cubit/my_cards_cubit.dart';

/// Hata durumunda gösterilen widget
class ErrorState extends StatelessWidget {
  final String? errorMessage;

  const ErrorState({
    super.key,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(    
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColorScheme.lightColorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage ?? 'Bir hata oluştu',
            style: TextStyle(
              color: AppColorScheme.lightColorScheme.error,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.read<MyCardsCubit>().getUserCards();
            },
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}
