

import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:lexilearnai/core/result/result.dart';
import 'package:lexilearnai/data/sources/auth/auth_supabase_service.dart';
import 'package:lexilearnai/domain/repository/auth/supabase_auth.dart';

class SupabaseAuthRepositoryImpl extends SupabaseAuth {
  @override
  Future<Result> getUser() {
    return serviceLocator<AuthSupabaseService>().getUser();
  }

  @override
  Future<Result> signInWithGoogle() {
    return serviceLocator<AuthSupabaseService>().googleSignIn();
  }

  @override
  Future<Result> signOut() {
    return serviceLocator<AuthSupabaseService>().signOut();
  }
}
