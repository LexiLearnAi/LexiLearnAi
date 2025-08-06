import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:lexilearnai/domain/usecase/auth/sign_out.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void onLogoutButtonPressed() async {
    emit(ProfileLogoutLoading());
    await serviceLocator<SignOutUseCase>().call().then(
      (value) {
        if (value.isFailure) {
          print(value.error);
          emit(ProfileLogoutFailure(value.error!));
        } else if (value.isSuccess) {
          emit(ProfileLogoutSuccess());
        }
      },
    );
  }
}
  