import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lexilearnai/common/init/application_initialize.dart';
import 'package:lexilearnai/common/navigation/app_router.dart';
import 'package:lexilearnai/core/config/theme/app_dark_theme.dart';
import 'package:lexilearnai/core/config/theme/app_light_theme.dart';
import 'package:lexilearnai/core/localizations/app_localizations.dart';


Future<void> main() async {
  await ApplicationInitialize.initialize();

  runApp(AppLocalizations(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LexiLearn',
      darkTheme: AppDarkTheme().themeData,
      theme: AppLightTheme().themeData,
      routerConfig: _appRouter.config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
