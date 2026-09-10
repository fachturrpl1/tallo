import 'package:flutter/material.dart';
import '../../components/transactions/transaction_search_bar.dart';
import '../../components/transactions/transaction_category_filter.dart';
import '../../components/transactions/dropdown/transaction_dropdown_filter.dart';
import '../../components/transactions/transaksi_card.dart';
import '../../models/transactions.dart';

class TransactionPage extends StatefulWidget {
  final List<Transactions> daftarTransaksi;

  const TransactionPage({super.key, required this.daftarTransaksi});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'Semua';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transactions> get _hasilFilter {
    return widget.daftarTransaksi.where((t) {
      final cocokJenis = _selectedType == 'Semua' || t.jenisLabel == _selectedType;
      final cocokCari = t.keterangan.toLowerCase().contains(_searchQuery);
      return cocokJenis && cocokCari;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi')),
      body: Column(
        children: [
          TransactionSearchBar(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          TransactionCategoryFilter(
            types: const ['Semua', 'Masuk', 'Keluar'],
            selectedType: _selectedType,
            onTypeSelected: (jenis) {
              setState(() {
                _selectedType = jenis;
              });
            },
          ),
          Row(
            children: [
              TransactionFilterDropdown(
                label: 'Semua Kategori',
                prefixIcon: Icons.filter_list,
                onTap: () {
                  // Handle dropdown tap
                },
              ),
              TransactionFilterDropdown(
                label: 'Terbaru',
                prefixIcon: Icons.calendar_today,
                onTap: () {
                  // Handle dropdown tap
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _hasilFilter.length,
              itemBuilder: (context, index) {
                final t = _hasilFilter[index];
                return TransactionCard(
                  keterangan: '', 
                  jenis: '', 
                  kategori: '', 
                  jumlah: 0, 
                  tanggal: '',
                  ); // sesuaikan dengan parameter TransaksiCard-mu
              },
            ),
          ),
        ],
      ),
    );
  }
}