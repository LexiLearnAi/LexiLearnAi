import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/cubit/modal_bottom_sheet_cubit.dart';

class SentenceSelectionView extends StatefulWidget {
  final CardEntity card;

  const SentenceSelectionView({
    super.key,
    required this.card,
  });

  @override
  State<SentenceSelectionView> createState() => _SentenceSelectionViewState();
}

class _SentenceSelectionViewState extends State<SentenceSelectionView> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: _buildSentenceList(),
          ),
        ),
        const SizedBox(height: 24),
        _buildSelectButton(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      "'${widget.card.word}' için örnek cümle seçin",
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
    );
  }

  Widget _buildSentenceList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.card.types[0].sentence.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildSentenceItem(index),
    );
  }

  Widget _buildSentenceItem(int index) {
    final isSelected = selected == "$index";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() {
            selected = (selected == "$index") ? null : "$index";
          }),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.grey[200]!.withOpacity(0.5),
                  blurRadius: isSelected ? 8 : 4,
                  offset: Offset(0, isSelected ? 2 : 1),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildCheckmark(isSelected),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.card.types[0].sentence[index],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isSelected ? Colors.black : Colors.black87,
                          height: 1.5,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckmark(bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Theme.of(context).primaryColor : Colors.white,
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.check,
        color: isSelected ? Colors.white : Colors.transparent,
        size: 16,
      ),
    );
  }

  Widget _buildSelectButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: selected != null ? _onSelectPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              "Cümleyi Seç",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectPressed() {
    if (selected != null) {
      final index = int.parse(selected!);
      context
          .read<ModalBottomSheetCubit>()
          .onSentenceSelected(widget.card, index);
      selected = null;
    }
  }
}
