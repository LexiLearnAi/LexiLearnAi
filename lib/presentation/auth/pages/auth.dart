import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/common/navigation/app_router.dart';
import 'package:lexilearnai/common/widgets/button/social_login_button.dart';
import 'package:lexilearnai/presentation/auth/cubit/auth_cubit.dart';

@RoutePage()
class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const Icon(
                Icons.school_outlined,
                size: 64,
                color: Colors.black87,
              ),
              const SizedBox(height: 40),
              _sloganText(),
              const Spacer(flex: 2),
              _buildAuthButtons(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Text _sloganText() {
    return Text(
      "general.slogan".tr(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  Widget _buildAuthButtons(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                  content:
                      Text(state.error)),
            );
          } else if (state is AuthSuccess) {
            context.router.replace(const WrapperRoute());
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
              ),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SocialLoginButton(
                bgColor: Colors.white,
                onPressed: () {
                  context.read<AuthCubit>().onGoogleButtonPressed();
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Giriş yaparak kullanım koşullarını kabul etmiş olursunuz.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
