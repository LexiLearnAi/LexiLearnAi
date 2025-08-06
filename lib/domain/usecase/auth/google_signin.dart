import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:lexilearnai/core/result/result.dart';
import 'package:lexilearnai/core/usecase/usecase.dart';
import 'package:lexilearnai/domain/repository/auth/supabase_auth.dart';

class GoogleSignInUseCase implements UseCase<Result, dynamic> {
  @override
  Future<Result> call({params}) async {
    return await serviceLocator<SupabaseAuth>().signInWithGoogle();
  }
}
