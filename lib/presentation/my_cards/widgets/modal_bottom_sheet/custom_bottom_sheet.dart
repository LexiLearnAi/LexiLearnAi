import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/cubit/modal_bottom_sheet_cubit.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/views/card_preview_view.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/views/initial_input_view.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/views/loading_view.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/views/sentence_selection_view.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/views/type_selection_view.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<ModalBottomSheetCubit, ModalBottomSheetState>(
      listener: (context, state) {
        if (state.status == ModalBottomSheetStatus.added) {
          Navigator.pop(context, state.selectedCard);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 4,
            ),
            constraints: BoxConstraints(
              // İlk görünüm için daha küçük bir yükseklik
              maxHeight: state.status == ModalBottomSheetStatus.initial
                  ? size.height * 0.4
                  : size.height * 0.75,
              // Minimum yükseklik garantisi
              minHeight: size.height * 0.3,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: _buildContent(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ModalBottomSheetState state) {
    switch (state.status) {
      case ModalBottomSheetStatus.initial:
        return const InitialInputView();
      case ModalBottomSheetStatus.loading:
        return const LoadingView();
      case ModalBottomSheetStatus.dataLoaded:
        return TypeSelectionView(card: state.data!);
      case ModalBottomSheetStatus.typeSelected:
        return SentenceSelectionView(card: state.selectedCard!);
      case ModalBottomSheetStatus.created:
        return CardPreviewView(card: state.selectedCard!);
      case ModalBottomSheetStatus.failure:
        return Center(child: Text(state.error ?? 'Bir hata oluştu'));
      default:
        return const LoadingView();
    }
  }
}

extension CustomBottomSheetExtension on CustomBottomSheet {
  Future<dynamic> show(
    BuildContext context,
    Size size, {
    bool enableDrag = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      context: context,
      barrierColor: Colors.black54,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 250), // Daha hızlı animasyon
      ),
      builder: (builderContext) {
        return BlocProvider(
          create: (context) => ModalBottomSheetCubit(),
          child: const CustomBottomSheet(),
        );
      },
    );
  }
}
