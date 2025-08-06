import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/card/card_item.dart';

/// Kart listesini gösteren widget
class CardList extends StatelessWidget {
  final List<CardEntity> cards;
  final bool isSelectionMode;
  final List<String> selectedCardIds;
  final Function(CardEntity) onCardTap;
  final Function(String) onCardDelete;
  final Function(String) onCardSelectionToggle;

  const CardList({
    super.key,
    required this.cards,
    required this.isSelectionMode,
    required this.selectedCardIds,
    required this.onCardTap,
    required this.onCardDelete,
    required this.onCardSelectionToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 100, // FAB için extra padding
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];

        if (isSelectionMode) {
          return _buildSelectableCardItem(context, card);
        }

        return Slidable(
          key: Key(card.id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (BuildContext slideContext) {
                  onCardDelete(card.id);
                },
                backgroundColor: AppColorScheme.lightColorScheme.error,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Sil',
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ],
          ),
          child: CardItem(
            card: card,
            onTap: () => onCardTap(card),
          ),
        );
      },
    );
  }

  /// Seçim modunda görüntülenecek kart öğesini oluşturur
  Widget _buildSelectableCardItem(BuildContext context, CardEntity card) {
    final isSelected = selectedCardIds.contains(card.id);

    return InkWell(
      onTap: () => onCardSelectionToggle(card.id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColorScheme.lightColorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
          color: isSelected
              ? AppColorScheme.lightColorScheme.primaryContainer
                  .withOpacity(0.3)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (bool? value) => onCardSelectionToggle(card.id),
              activeColor: AppColorScheme.lightColorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: CardItem(
                card: card,
                onTap: () => onCardSelectionToggle(card.id),
                disableTapAnimation: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
