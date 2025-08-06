import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/modal_bottom_sheet/cubit/modal_bottom_sheet_cubit.dart';

class TypeSelectionView extends StatefulWidget {
  final CardEntity card;

  const TypeSelectionView({
    super.key,
    required this.card,
  });     

  @override
  State<TypeSelectionView> createState() => _TypeSelectionViewState();
}

class _TypeSelectionViewState extends State<TypeSelectionView> {
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
            child: _buildTypeList(),
          ),
        ),
        const SizedBox(height: 24),
        _buildContinueButton(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      "'${widget.card.word}' kelimesi için bir anlam seçin",
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
    );
  }

  Widget _buildTypeList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.card.types.length,
      itemBuilder: (context, index) => _buildTypeItem(index),
    );
  }

  Widget _buildTypeItem(int index) {
    final typeData = widget.card.types[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTypeHeader(typeData.type),
        const SizedBox(height: 16),
        ...typeData.definition.asMap().entries.map(
              (entry) => _buildDefinitionItem(index, entry.key, entry.value),
            ),
        if (index < widget.card.types.length - 1) const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTypeHeader(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        type.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              fontSize: 14,
            ),
      ),
    );
  }

  Widget _buildDefinitionItem(
      int typeIndex, int definitionIndex, String definition) {
    String itemKey = "$typeIndex-$definitionIndex";
    final isSelected = selected == itemKey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() {
              selected = (selected == itemKey) ? null : itemKey;
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
                      definition,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isSelected ? Colors.black : Colors.black87,
                            height: 1.5,
                            fontWeight: isSelected
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
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

  Widget _buildContinueButton() {
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
      child: Material(
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: selected != null ? _onContinuePressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            padding: EdgeInsets.zero,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "Devam Et",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinuePressed() {
    if (selected != null) {
      final parts = selected!.split('-');
      final typeIndex = int.parse(parts[0]);
      final definitionIndex = int.parse(parts[1]);

      context.read<ModalBottomSheetCubit>().onTypeSelected(
            widget.card,
            type: typeIndex,
            definition: definitionIndex,
          );
      selected = null;
    }
  }
}
