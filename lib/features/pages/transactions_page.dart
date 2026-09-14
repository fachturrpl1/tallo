import 'package:flutter/material.dart';
import '../widgets/transactions/transaction_search_bar.dart';
import '../widgets/transactions/transaction_category_filter.dart';
import '../widgets/transactions/dropdown/transaction_dropdown_filter.dart';
import '../widgets/transactions/card/transactions_card.dart';
import '../models/transactions.dart';

class TransactionsPage extends StatefulWidget {
  final List<Transactions> transactionsList;

  const TransactionsPage({super.key, required this.transactionsList});

  @override
  State<TransactionsPage> createState() => _TransactionPageState();
}
enum SortOrder { latest, oldest}

class _TransactionPageState extends State<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool? _selectedMasuk;
  String _searchQuery = '';
  SortOrder _sortOrder = SortOrder.latest;

  String get _sortLabel =>
    _sortOrder == SortOrder.latest ? 'Terbaru' : 'Terlama'; 

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transactions> get _hasilFilter {
    final hasil = widget.transactionsList.where((t) {
        // Bandingkan langsung sebagai bool, tidak lewat String lagi
        final bool cocokJenis = _selectedMasuk == null || t.masuk == _selectedMasuk;

        final String query = _searchQuery.trim().toLowerCase();
        final bool cocokCari = query.isEmpty || t.keterangan.toLowerCase().contains(query);

        return cocokJenis && cocokCari;
    }).toList();

    hasil.sort((a, b) => _sortOrder == SortOrder.latest
      ? b.tanggal.compareTo(a.tanggal)
      : a.tanggal.compareTo(b.tanggal));

    return hasil;
  }

  Future<void> _showSortMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height + 4), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu<SortOrder>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(value: SortOrder.latest, child: Text('Terbaru')),
        PopupMenuItem(value: SortOrder.oldest, child: Text('Terlama')),
      ],
    );

    if (result != null) {
      setState(() => _sortOrder = result);
    }
  }

  // helper untuk konversi label String dari UI -> bool? untuk state
  void _handleTypeSelected(String label) {
    setState(() {
      _selectedMasuk = switch (label) {
        'Masuk' => true,
        'Keluar' => false,
        _ => null, // 'Semua' atau apapun selain itu
      };
    });
  }

  // helper untuk konversi bool? -> String label untuk ditampilkan sebagai selected di UI
  String get _selectedTypeLabel {
    return switch (_selectedMasuk) {
      true => 'Masuk',
      false => 'Keluar',
      null => 'Semua',
    };
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _hasilFilter;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final contentWidth = constraints.maxWidth;
                final searchWidth = contentWidth < 600 ? contentWidth : 600.0;

                return Wrap(
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
                          types: const ['Semua', 'Masuk', 'Keluar'],
                          selectedType: _selectedTypeLabel,
                          onTypeSelected: _handleTypeSelected,
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
                            Builder(
                              builder:(context) => TransactionFilterDropdown(
                                label: _sortLabel,
                                prefixIcon: Icons.calendar_today,
                                onTap: () => _showSortMenu(context)),
                              )
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada transaksi ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      int kolom;
                      if (constraints.maxWidth < 600) {
                        kolom = 1;
                      } else if (constraints.maxWidth < 900) {
                        kolom = 2;
                      } else {
                        kolom = 3;
                      }

                      return GridView.builder(
                        itemCount: filteredList.length,
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: kolom,
                          mainAxisExtent: 72, // Tinggi Card ideal untuk ListTile transaksi
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return TransactionCard(transaction: item);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}