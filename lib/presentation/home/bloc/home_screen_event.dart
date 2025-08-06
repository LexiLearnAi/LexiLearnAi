part of 'home_screen_bloc.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

final class HomeScreenDaySelected extends HomeScreenEvent {
  final DateTime selectedDay;

  const HomeScreenDaySelected(this.selectedDay);
}
