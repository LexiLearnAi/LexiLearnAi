part of 'modal_bottom_sheet_cubit.dart';

enum ModalBottomSheetStatus {
  initial,
  loading,
  failure,
  added,
  created,
  typeSelected,
  dataLoaded,
}

class ModalBottomSheetState extends Equatable {
  final ModalBottomSheetStatus status;
  final CardEntity? selectedCard;
  final CardEntity? data;
  final String? error;

  const ModalBottomSheetState({
    this.status = ModalBottomSheetStatus.initial,
    this.selectedCard,
    this.data,
    this.error,
  });

  ModalBottomSheetState copyWith({
    ModalBottomSheetStatus? status,
    CardEntity? selectedCard,
    CardEntity? data,
    String? error,
  }) {
    return ModalBottomSheetState(
      status: status ?? this.status,
      selectedCard: selectedCard ?? this.selectedCard,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, selectedCard, data, error];
}
