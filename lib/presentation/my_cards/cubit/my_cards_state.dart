part of 'my_cards_cubit.dart';

enum MyCardsStatus {
  initial,
  loading,
  success,
  failure,
}

class MyCardsState extends Equatable {
  final MyCardsStatus status;
  final List<CardEntity> cards;
  final List<CardEntity> filteredCards;
  final String? error;
  final Set<String> loadedImageUrls;
  final bool isSelectionMode;
  final Set<String> selectedCardIds;

  const MyCardsState({
    this.status = MyCardsStatus.initial,
    this.cards = const [],
    this.filteredCards = const [],
    this.error,
    this.loadedImageUrls = const {},
    this.isSelectionMode = false,
    this.selectedCardIds = const {},
  });

  MyCardsState copyWith({
    MyCardsStatus? status,
    List<CardEntity>? cards,
    List<CardEntity>? filteredCards,
    String? error,
    Set<String>? loadedImageUrls,
    bool? isSelectionMode,
    Set<String>? selectedCardIds,
  }) {
    return MyCardsState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      filteredCards: filteredCards ?? this.filteredCards,
      error: error ?? this.error,
      loadedImageUrls: loadedImageUrls ?? this.loadedImageUrls,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedCardIds: selectedCardIds ?? this.selectedCardIds,
    );
  }

  @override
  List<Object?> get props => [
        status,
        cards,
        filteredCards,
        error,
        loadedImageUrls,
        isSelectionMode,
        selectedCardIds,
      ];
}
