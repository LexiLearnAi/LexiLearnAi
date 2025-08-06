import 'package:lexilearnai/core/result/result.dart';

abstract class SupabaseAuth {
  Future<Result> signInWithGoogle();
  Future<Result> signOut();
  Future<Result> getUser();
}
