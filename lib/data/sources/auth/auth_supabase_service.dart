import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:lexilearnai/core/result/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthSupabaseService {
  Future<Result> googleSignIn();
  Future<Result> signOut();
  Future<Result> getUser();
}

class AuthSupabaseServiceImpl extends AuthSupabaseService {
  final supabase = Supabase.instance.client;
  @override
  Future<Result> getUser() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser != null) {
        return Result.success(currentUser);
      } else {
        return Result.failure('Kullanıcı oturum açmamış');
      }
    } catch (e) {
      return Result.failure('Kullanıcı bilgileri alınamadı: ${e.toString()}');
    }
  }

  @override
  Future<Result> googleSignIn() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId:
            '519900424946-rau5921jmdr2nv0itm3gqfculv4esmku.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.authenticate();
  

      final googleAuth =  googleUser.authentication;
      final accessToken = googleAuth.idToken;
      

      if (accessToken == null) {
        throw 'No Access Token found.';
      }


      final authResponse = supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: accessToken,
        accessToken: accessToken,
      );
      log(authResponse.toString());

      return Result.success(authResponse);
    } catch (e) {
      return Result.failure("Google sign-in failed: ${e.toString()}");
    }
  }

  @override
  Future<Result> signOut() async {
    try {
      await supabase.auth.signOut();
      return Result.success("User signed out");
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
