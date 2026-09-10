import 'package:flutter/material.dart';

class TransactionSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const TransactionSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Warna latar belakang disamakan dengan pill
        borderRadius: BorderRadius.circular(20), // Radius melengkung seperti pill
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Cari transaksi...',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
          border: InputBorder.none, // Menghilangkan border garis tepi bawaan
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}