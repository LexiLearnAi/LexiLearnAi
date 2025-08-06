import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';

part 'my_cards_state.dart';

class MyCardsCubit extends Cubit<MyCardsState> {
  MyCardsCubit() : super(const MyCardsState());

  Future<void> getUserCards() async {}

  void addCard(CardEntity card) {
    final updatedCards = [...state.cards, card];
    emit(
      state.copyWith(
        status: MyCardsStatus.success,
        cards: updatedCards,
        filteredCards: updatedCards,
      ),
    );
  }

  void searchCards(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredCards: state.cards));
      return;
    }

    final filteredCards = state.cards.where((card) {
      final word = card.word.toLowerCase();
      final searchQuery = query.toLowerCase();

      return word.contains(searchQuery) ||
          card.types.any(
            (type) => type.definition.any(
              (def) => def.toLowerCase().contains(searchQuery),
            ),
          );
    }).toList();

    emit(state.copyWith(filteredCards: filteredCards));
  }

  void filterByLearningStatus(bool isLearned) {
    final filteredCards = state.cards.where((card) {
      // TODO: Implement learning status logic
      return true;
    }).toList();

    emit(state.copyWith(filteredCards: filteredCards));
  }

  void clearSearch() {
    emit(state.copyWith(filteredCards: state.cards));
  }

  Future<void> deleteCard(String cardId) async {
    if (cardId.isEmpty) {
      emit(
        state.copyWith(
          status: MyCardsStatus.failure,
          error: 'Card ID boş olamaz',
        ),
      );
      return;
    }

    emit(state.copyWith(status: MyCardsStatus.loading));
  }

  /// Seçim modunu açıp/kapatır
  void toggleSelectionMode() {
    if (state.isSelectionMode) {
      emit(state.copyWith(isSelectionMode: false, selectedCardIds: {}));
    } else {
      emit(state.copyWith(isSelectionMode: true));
    }
  }

  /// Belirli bir kartın seçim durumunu değiştirir
  void toggleCardSelection(String cardId) {
    if (!state.isSelectionMode) return;

    final selectedCardIds = Set<String>.from(state.selectedCardIds);
    if (selectedCardIds.contains(cardId)) {
      selectedCardIds.remove(cardId);
    } else {
      selectedCardIds.add(cardId);
    }

    emit(state.copyWith(selectedCardIds: selectedCardIds));
  }

  /// Tüm kartları seçer
  void selectAllCards() {
    if (!state.isSelectionMode) return;

    final allCardIds = state.filteredCards.map((card) => card.id).toSet();
    emit(state.copyWith(selectedCardIds: allCardIds));
  }

  /// Seçimi temizler
  void clearSelection() {
    emit(state.copyWith(selectedCardIds: {}));
  }

  /// Bir kartın seçili olup olmadığını kontrol eder
  bool isCardSelected(String cardId) {
    return state.selectedCardIds.contains(cardId);
  }

  /// Seçilen kartları döndürür
  List<CardEntity> getSelectedCards() {
    return state.cards
        .where((card) => state.selectedCardIds.contains(card.id))
        .toList();
  }

  /// Bir resmin yüklendiğini işaretler
  void markImageAsLoaded(String imageUrl) {
    if (imageUrl.isEmpty || state.loadedImageUrls.contains(imageUrl)) {
      return;
    }

    final Set<String> updatedLoadedImageUrls = {
      ...state.loadedImageUrls,
      imageUrl,
    };
    emit(state.copyWith(loadedImageUrls: updatedLoadedImageUrls));
  }

  /// Bir resmin yüklenip yüklenmediğini kontrol eder
  bool isImageLoaded(String imageUrl) {
    return state.loadedImageUrls.contains(imageUrl);
  }
}
