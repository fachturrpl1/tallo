import 'package:flutter/material.dart';

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
              selectedColor: const Color(0xFF007A60), // Warna hijau sesuai UI
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              showCheckmark: false,
              side: BorderSide.none,
            ),
          );
        }).toList(),
      ),
    );
  }
}