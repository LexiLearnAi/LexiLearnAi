import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/presentation/my_cards/cubit/my_cards_cubit.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/list_view/card_list/card_list.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/list_view/dialogs/card_detail_dialog.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/list_view/dialogs/delete_confirmation_dialog.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/list_view/states/empty_state.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/list_view/states/error_state.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/list_view/states/loading_state.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/list_view/states/no_search_result_state.dart';

/// Kartların liste görünümünü sağlayan ana widget
class CustomListView extends StatelessWidget {
  const CustomListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCardsCubit, MyCardsState>(
      builder: (context, state) {
        switch (state.status) {
          case MyCardsStatus.initial:
            return const LoadingState();
          case MyCardsStatus.loading:
            return const LoadingState();
          case MyCardsStatus.failure:
            return ErrorState(errorMessage: state.error);
          case MyCardsStatus.success:
            if (state.cards.isEmpty) {
              return const EmptyState();
            }
            if (state.filteredCards.isEmpty && state.cards.isNotEmpty) {
              return const NoSearchResultState();
            }
            return CardList(
              cards: state.filteredCards,
              isSelectionMode: state.isSelectionMode,
              selectedCardIds: state.selectedCardIds.toList(),
              onCardTap: (card) => _showCardDetailDialog(context, card),
              onCardDelete: (cardId) =>
                  _showDeleteConfirmationDialog(context, cardId),
              onCardSelectionToggle: (cardId) =>
                  context.read<MyCardsCubit>().toggleCardSelection(cardId),
            );
        }
      },
    );
  }

  /// Silme işlemi için onay dialog'u
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String cardId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => const DeleteConfirmationDialog(),
    );

    if (result == true) {
      context.read<MyCardsCubit>().deleteCard(cardId);
    }
  }

  /// Kart detay dialogunu gösteren metod
  void _showCardDetailDialog(BuildContext context, CardEntity card) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => CardDetailDialog(card: card),
    );
  }
}
