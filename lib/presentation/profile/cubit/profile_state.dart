part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLogoutLoading extends ProfileState {}

final class ProfileLogoutSuccess extends ProfileState {}

final class ProfileLogoutFailure extends ProfileState {
  final String errorMessage;

  const ProfileLogoutFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
