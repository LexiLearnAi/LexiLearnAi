import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexilearnai/core/config/assets/app_vector.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton(
      {super.key, required this.onPressed, required this.bgColor});
  final VoidCallback onPressed;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(size.width * 0.9, 75)),
          backgroundColor:
              WidgetStatePropertyAll(AppColorScheme.lightColorScheme.surface),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              side: BorderSide(
                width: 2,
                color: AppColorScheme.lightColorScheme.outline,
              ),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppVectors.googleIcon,
              height: 24,
              width: 24,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Continue with Google",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
