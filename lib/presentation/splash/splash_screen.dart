import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lexilearnai/common/navigation/app_router.dart';
import 'package:lexilearnai/presentation/splash/cubit/splash_cubit.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..getUser(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (kIsWeb) {
            // Web sayfasına manuel olarak yönlendir
           
          } else if (state is SplashAuthenticated) {
            context.router.replace(const HomeRoute());
          } else if (state is SplashUnauthenticated) {
            context.router.replace(LoginOrRegisterRoute());
          }
          FlutterNativeSplash.remove();
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
