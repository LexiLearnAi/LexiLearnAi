import 'package:get_it/get_it.dart';
import 'package:lexilearnai/data/repository/auth/supabase_auth.dart';
import 'package:lexilearnai/data/repository/card/card.dart';
import 'package:lexilearnai/data/sources/auth/auth_supabase_service.dart';
import 'package:lexilearnai/data/sources/card/card_supabase_service.dart';
import 'package:lexilearnai/domain/repository/auth/supabase_auth.dart';
import 'package:lexilearnai/domain/repository/card/card.dart';
import 'package:lexilearnai/domain/usecase/auth/get_user.dart';
import 'package:lexilearnai/domain/usecase/auth/google_signin.dart';
import 'package:lexilearnai/domain/usecase/auth/sign_out.dart';
import 'package:lexilearnai/domain/usecase/card/add_card.dart';
import 'package:lexilearnai/domain/usecase/card/get_photo.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  ///Services

  serviceLocator.registerSingleton<AuthSupabaseService>(
    AuthSupabaseServiceImpl(),
  );

  serviceLocator.registerSingleton<CardSupabaseService>(
    CardSupabaseServiceImpl(),
  );

  // firestore

  ///UseCases
  serviceLocator.registerSingleton<AddCardUseCase>(AddCardUseCase());
  serviceLocator.registerSingleton<GoogleSignInUseCase>(GoogleSignInUseCase());
  serviceLocator.registerSingleton<GetUserUseCase>(GetUserUseCase());
  serviceLocator.registerSingleton<SignOutUseCase>(SignOutUseCase());
  serviceLocator.registerSingleton<GetPhotoUseCase>(GetPhotoUseCase());

  ///Repositories
  serviceLocator.registerSingleton<CardRepository>(CardRepositoryImpl());

  serviceLocator.registerSingleton<SupabaseAuth>(SupabaseAuthRepositoryImpl());

  // Cubits
}
