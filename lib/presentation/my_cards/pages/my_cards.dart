import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';
import 'package:lexilearnai/presentation/my_cards/cubit/my_cards_cubit.dart';
import 'package:lexilearnai/presentation/my_cards/study_plan/widgets/study_plan_sheet.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/list_view/custom_list_view.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/custom_bottom_sheet.dart';

class MyCardsView extends StatelessWidget {
  const MyCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<MyCardsCubit, MyCardsState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: state.isSelectionMode
                ? _buildSelectionModeAppBar(context, state, size)
                : _buildAppBar(context, size),
            body: Column(
              children: [
                if (!state.isSelectionMode) _buildTabBar(context),
                const Expanded(
                  child: TabBarView(
                    children: [
                      CustomListView(),
                      _LearnedCardsView(),
                      _UnlearnedCardsView(),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: state.isSelectionMode
                ? _buildSelectionModeFloatingActionButton(context, state, size)
                : _buildFloatingActionButtons(context, size),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Size size) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Column(
        children: [
          const Text(
            'My Cards',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSearchBar(context),
        ],
      ),
      centerTitle: true,
      toolbarHeight: size.height * 0.15,
    );
  }

  PreferredSizeWidget _buildSelectionModeAppBar(
      BuildContext context, MyCardsState state, Size size) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColorScheme.lightColorScheme.primary,
      foregroundColor: Colors.white,
      title: Text(
        '${state.selectedCardIds.length} kart seçildi',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          context.read<MyCardsCubit>().toggleSelectionMode();
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<MyCardsCubit>().selectAllCards();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'Tümünü Seç',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColorScheme.lightColorScheme.surfaceContainerHighest
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        padding: const EdgeInsets.all(4),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColorScheme.lightColorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: AppColorScheme.lightColorScheme.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppColorScheme.lightColorScheme.onSurfaceVariant,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Learned'),
          Tab(text: 'Unlearned'),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SearchBar(
      hintText: 'Kartlarda ara...',
      onChanged: (value) {
        context.read<MyCardsCubit>().searchCards(value);
      },
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColorScheme.lightColorScheme.outline.withOpacity(0.3),
          ),
        ),
      ),
      leading: Icon(
        Icons.search,
        color: AppColorScheme.lightColorScheme.primary,
      ),
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(
        AppColorScheme.lightColorScheme.surfaceContainerHighest
            .withOpacity(0.1),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      trailing: [
        IconButton(
          icon: Icon(
            Icons.clear,
            color: AppColorScheme.lightColorScheme.primary,
          ),
          onPressed: () {
            context.read<MyCardsCubit>().clearSearch();
          },
        ),
      ],
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FloatingActionButton(
            label: 'Add Card',
            icon: Icons.add,
            color: AppColorScheme.lightColorScheme.primary,
            onPressed: () async {
              final result = await CustomBottomSheet().show(context, size);
              if (result != null && context.mounted) {
                context.read<MyCardsCubit>().addCard(result);
              }
            },
          ),
          _FloatingActionButton(
            label: 'Make Plan',
            icon: Icons.calendar_today,
            color: AppColorScheme.lightColorScheme.secondary,
            onPressed: () {
              context.read<MyCardsCubit>().toggleSelectionMode();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionModeFloatingActionButton(
      BuildContext context, MyCardsState state, Size size) {
    return FloatingActionButton.extended(
      onPressed: () {
        final selectedCards = context.read<MyCardsCubit>().getSelectedCards();
        // Boş seçim kontrolü
        if (selectedCards.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lütfen en az bir kart seçin'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        // Çalışma planı bottom sheet'ini göster
        StudyPlanSheet().show(context, selectedCards).then((dailyPlans) {
          // İşlem tamamlandıktan sonra seçim modunu kapat
          if (context.mounted) {
            context.read<MyCardsCubit>().toggleSelectionMode();

            // Eğer plan oluşturulduysa başarı mesajı göster
            if (dailyPlans != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Çalışma planınız başarıyla oluşturuldu!'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        });
      },
      backgroundColor: AppColorScheme.lightColorScheme.primary,
      elevation: 6,
      highlightElevation: 10,
      icon: const Icon(Icons.check, color: Colors.white),
      label: const Text(
        'Plan Oluştur',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _FloatingActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: color,
      elevation: 4,
      highlightElevation: 8,
      label: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnedCardsView extends StatelessWidget {
  const _LearnedCardsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Learned Cards',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class _UnlearnedCardsView extends StatelessWidget {
  const _UnlearnedCardsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Unlearned Cards',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
