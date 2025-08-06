import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lexilearnai/common/navigation/app_router.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';

@RoutePage()
class WrapperScreen extends StatelessWidget {
  const WrapperScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      resizeToAvoidBottomInset: false,
      routes: const [
        HomeRoute(),
        MyCardsRoute(),
        ProfileRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: _iconWidget("home", 0, tabsRouter),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: _iconWidget("cards", 1, tabsRouter),
              label: "Cards",
            ),
            BottomNavigationBarItem(
              icon: _iconWidget("user", 2, tabsRouter),
              label: "Profile",
            ),
          ],
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
        );
      },
    );
  }
}

Widget _iconWidget(String icon, int index, TabsRouter tabsRouter) {
  return tabsRouter.activeIndex != index
      ? SvgPicture.asset(
          'assets/icon_svg/$icon.svg',
          width: 25,
          height: 25,
        )
      : SvgPicture.asset(
          'assets/icon_svg/${icon}_selected.svg',
          width: 30,
          height: 30,
          colorFilter: ColorFilter.mode(
              AppColorScheme.lightColorScheme.primary, BlendMode.srcIn),
        );
}
