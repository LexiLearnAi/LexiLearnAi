import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitial(selectedDay: DateTime.now())) {
    on<HomeScreenEvent>((event, emit) {});
    on<HomeScreenDaySelected>(_homeScreenDaySelected);
  }

  FutureOr<void> _homeScreenDaySelected(
      HomeScreenDaySelected event, Emitter<HomeScreenState> emit) {
    emit(HomeScreenInitial(selectedDay: event.selectedDay));
  }
}
