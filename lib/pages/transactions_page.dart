import 'package:flutter/material.dart';
import '../widgets/transactions/transaction_search_bar.dart';
import '../widgets/transactions/transaction_category_filter.dart';
import '../widgets/transactions/dropdown/transaction_dropdown_filter.dart';
import '../widgets/transactions/transaksi_card.dart';
import '../../models/transactions.dart';

class TransactionPage extends StatefulWidget {
  final List<Transactions> TransactionsList;

  const TransactionPage({super.key, required this.TransactionsList});

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
    return widget.TransactionsList.where((t) {
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
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const horizontalPadding = 16.0;

                final contentWidth =
                    constraints.maxWidth - (horizontalPadding * 2);

                final searchWidth = contentWidth < 600
                    ? contentWidth
                    : 600.0;

                return Padding(
                  padding: const EdgeInsets.all(horizontalPadding),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: searchWidth,
                        child: TransactionSearchBar(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                      ),

                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          TransactionCategoryFilter(
                            types: const [
                              'Semua',
                              'Masuk',
                              'Keluar',
                            ],
                            selectedType: _selectedType,
                            onTypeSelected: (jenis) {
                              setState(() {
                                _selectedType = jenis;
                              });
                            },
                          ),

                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              TransactionFilterDropdown(
                                label: 'Semua Kategori',
                                prefixIcon: Icons.filter_list,
                                onTap: () {},
                              ),
                              TransactionFilterDropdown(
                                label: 'Terbaru',
                                prefixIcon: Icons.calendar_today,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

          )
        ]
      ),
    );
  }
}