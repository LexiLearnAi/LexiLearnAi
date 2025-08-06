import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:lexilearnai/data/model/card/photo_response.dart';
import 'package:lexilearnai/data/sources/card/card_supabase_service.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/domain/usecase/card/get_photo.dart';


part 'modal_bottom_sheet_state.dart';

class ModalBottomSheetCubit extends Cubit<ModalBottomSheetState> {
  ModalBottomSheetCubit() : super(const ModalBottomSheetState());

  StreamSubscription? _subscription;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  Future<void> onAddWordButtonClicked(String word) async {
    emit(state.copyWith(status: ModalBottomSheetStatus.loading));
    try {
      final result = await CardSupabaseServiceImpl().askForCard(word);
      if (!isClosed) {
        if (result.isFailure) {
          emit(state.copyWith(
              status: ModalBottomSheetStatus.failure, error: result.error!));
        } else if (result.isSuccess) {
          emit(state.copyWith(
              status: ModalBottomSheetStatus.dataLoaded, data: result.data));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
            status: ModalBottomSheetStatus.failure, error: e.toString()));
      }
    }
  }

  Future<void> onTypeSelected(CardEntity card,
      {required int type, required int definition}) async {
    if (isClosed) return;
    card.types = [card.types[type]];
    card.types[0].definition = [card.types[0].definition[definition]];

    emit(state.copyWith(
        status: ModalBottomSheetStatus.typeSelected, selectedCard: card));
  }

  Future<void> onSentenceSelected(CardEntity card, int index) async {
    if (isClosed) return;
    emit(state.copyWith(status: ModalBottomSheetStatus.loading));
    try {
      card.types[0].sentence = [card.types[0].sentence[index]];

      final photoResult = await serviceLocator<GetPhotoUseCase>()
          .call(params: GetPhotoParams(card.types[0].id));

      if (isClosed) return;

      if (photoResult.isFailure) {
        emit(state.copyWith(
            status: ModalBottomSheetStatus.failure, error: photoResult.error!));
        return;
      }

      if (photoResult.data == null) {
        emit(state.copyWith(
            status: ModalBottomSheetStatus.failure,
            error: 'Fotoğraf verileri alınamadı'));
        return;
      }

      PhotoResponse photoUrls = photoResult.data!;
      card.types[0].photo = photoUrls.originalUrl;
      

      emit(state.copyWith(
          status: ModalBottomSheetStatus.created, selectedCard: card));
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
            status: ModalBottomSheetStatus.failure, error: e.toString()));
      }
    }
  }

  Future<void> onConfirmButtonClicked(CardEntity card) async {
    emit(state.copyWith(status: ModalBottomSheetStatus.loading));
    try {
      final result = await CardSupabaseServiceImpl().addCard(card);
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(status: ModalBottomSheetStatus.failure, error: e.toString()));
      }
    }
  }

  void onCardCreated(CardEntity card) {
    if (isClosed) return;
    emit(state.copyWith(
      status: ModalBottomSheetStatus.created,
      selectedCard: card,
    ));
  }
}
