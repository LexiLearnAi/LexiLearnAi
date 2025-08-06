import 'package:flutter/material.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';

/// Silme işlemi için onay dialog'u
class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kartı Sil'),
      content: const Text('Bu kartı silmek istediğinizden emin misiniz?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // İptal et
          },
          child: const Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Onayla
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColorScheme.lightColorScheme.error,
          ),
          child: const Text('Sil'),
        ),
      ],
    );
  }
}
