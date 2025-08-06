import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/presentation/my_cards/cubit/my_cards_cubit.dart';
import 'package:lexilearnai/presentation/my_cards/pages/my_cards.dart';

@RoutePage()
class MyCardsScreen extends StatelessWidget {
  const MyCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MyCardsCubit()..getUserCards(),
        ),
      ],
      child: const MyCardsView(),
      );
    }
}
