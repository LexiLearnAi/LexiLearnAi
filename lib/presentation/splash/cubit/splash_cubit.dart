import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:lexilearnai/domain/usecase/auth/get_user.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> getUser() async {
    await serviceLocator<GetUserUseCase>().call().then((value) {
      if (value.isFailure) {
        emit(SplashUnauthenticated());
      } else if (value.isSuccess) {
        emit(SplashAuthenticated());
      }
    });
  } 
}
