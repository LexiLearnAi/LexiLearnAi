import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/common/widgets/button/app_default_button.dart';
import 'package:lexilearnai/common/widgets/flip_card/app_flip_card.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/cubit/modal_bottom_sheet_cubit.dart';

class CardPreviewView extends StatelessWidget {
  final CardEntity card;

  const CardPreviewView({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "Kartınızı inceleyin",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: AppFlipCard(card: card),
            ),
          ],
        ),
        AppDefaultButton(
          labelText: "Onayla",
          onPressed: () {
            context.read<ModalBottomSheetCubit>().onConfirmButtonClicked(card);
          },
        ),
      ],
    );
  }
}
