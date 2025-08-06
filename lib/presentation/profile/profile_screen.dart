import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/common/navigation/app_router.dart';
import 'package:lexilearnai/presentation/profile/cubit/profile_cubit.dart';

@RoutePage()    
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (cubitContext) => ProfileCubit(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogoutSuccess) {
            context.router.popUntilRoot();
            context.router.replaceAll([const LoginOrRegisterRoute()]);
          }

          if (state is ProfileLogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Çıkış yaparken hata oluştu: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLogoutLoading) {
                      return const CircularProgressIndicator();
                    }

                    return ElevatedButton(
                      child: const Text("Logout"),
                      onPressed: () {
                        context.read<ProfileCubit>().onLogoutButtonPressed();
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
