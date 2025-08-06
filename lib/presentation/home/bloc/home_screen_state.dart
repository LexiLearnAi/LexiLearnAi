part of 'home_screen_bloc.dart';

sealed class HomeScreenState extends Equatable {
  final DateTime selectedDay;
  const HomeScreenState({required this.selectedDay});

  @override
  List<Object> get props => [];
}

final class HomeScreenInitial extends HomeScreenState {
  const HomeScreenInitial({required super.selectedDay});

  @override
  List<Object> get props => [selectedDay];
}
