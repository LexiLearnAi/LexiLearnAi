import 'package:auto_route/auto_route.dart';
import 'package:lexilearnai/presentation/auth/pages/auth.dart';
import 'package:lexilearnai/presentation/home/pages/daily_cards.dart';
import 'package:lexilearnai/presentation/home/pages/home_navigation_screen.dart';
import 'package:lexilearnai/presentation/home/pages/home_screen.dart';
import 'package:lexilearnai/presentation/home/pages/your_cards.dart';
        
import 'package:lexilearnai/presentation/my_cards/pages/my_cards_page.dart';
import 'package:lexilearnai/presentation/profile/profile_screen.dart';
import 'package:lexilearnai/presentation/splash/splash_screen.dart';
import 'package:lexilearnai/presentation/wrapper/view/wrapper_screen.dart';

part 'app_router.gr.dart'; // This is the generated file

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        /// routes go here
        AutoRoute(
          page: SplashRoute.page,
          path: '/',
          initial: true,
        ),
       
        AutoRoute(
          page: LoginOrRegisterRoute.page,
          path: '/login_or_register',
        ),

        CustomRoute(
            page: WrapperRoute.page,
            path: '/wrapper',
            transitionsBuilder: TransitionsBuilders.slideLeft,
            duration: const Duration(milliseconds: 500),
            children: [
              AutoRoute(page: HomeNavigationRoute.page, children: [
                AutoRoute(page: HomeRoute.page, initial: true),
                CustomRoute(
                    page: YourCardsRoute.page,
                    transitionsBuilder: TransitionsBuilders.zoomIn,
                    duration: const Duration(milliseconds: 500)),
                CustomRoute(
                    page: DailyCardsRoute.page,
                    transitionsBuilder: TransitionsBuilders.zoomIn,
                    duration: const Duration(milliseconds: 500)),
              ]),
              AutoRoute(page: MyCardsRoute.page, path: 'words'),
              AutoRoute(
                page: ProfileRoute.page,
                path: 'profile',
              ),
              AutoRoute(page: YourCardsRoute.page, path: 'your_cards'),
            ]),
      ];
}
