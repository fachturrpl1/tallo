import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TransactionCategoryFilter extends StatelessWidget {
  final List<String> types;
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const TransactionCategoryFilter({
    super.key,
    required this.types,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((type) {
          final isSelected = type == selectedType;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (_) => onTypeSelected(type),
              selectedColor: colorScheme.primary, // Warna utama sesuai AppColors Theme
              backgroundColor: colorScheme.surfaceVariant, // Menyesuaikan mode terang/gelap
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : colorScheme.outlineVariant,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}