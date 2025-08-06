import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:lexilearnai/domain/usecase/auth/google_signin.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> onGoogleButtonPressed() async {
    emit(AuthLoading());
    await serviceLocator<GoogleSignInUseCase>().call().then((value) {
      if (value.isSuccess) {
        emit(AuthSuccess());
      } else if (value.isFailure) {
        emit(AuthFailure(error: value.error!));
      }
    });
  }
}
