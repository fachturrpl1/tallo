import 'package:flutter/material.dart';
import 'package:tallo/features/widgets/transactions/transaction_emptystate.dart';
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

enum DateSortOrder { latest, oldest }
enum PriceSortOrder { highest, lowest }
enum _SortPriority { date, price}

class _TransactionPageState extends State<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();

  bool? _selectedMasuk;
  String _searchQuery = '';

  DateSortOrder _dateOrder = DateSortOrder.latest;
  PriceSortOrder? _priceSort;
  _SortPriority _sortPriority = _SortPriority.date;

  String? _selectedCategory;

  String get _sortLabel {
    return _dateOrder == DateSortOrder.latest ? 'Terbaru' : 'Terlama';
  }

  String get _priceSortLabel {
    return switch (_priceSort) {
      PriceSortOrder.highest => 'Tertinggi',
      PriceSortOrder.lowest => 'Terendah',
      null => 'Harga',
    };
  }

  String get _categoryLabel {
    if (_selectedCategory == null) return 'Semua Kategori';
    return Transactions.categoriesOption
        .firstWhere(
          (c) => c.id == _selectedCategory,
          orElse: () => const CategoriesOption('', 'Semua Kategori'),
        )
        .label;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transactions> get _hasilFilter {
    final hasil = widget.transactionsList.where((t) {
      final bool cocokJenis = _selectedMasuk == null || t.masuk == _selectedMasuk;
      final String query = _searchQuery.trim().toLowerCase();
      final bool cocokCari = query.isEmpty || t.keterangan.toLowerCase().contains(query);
      final bool cocokKategori =
          _selectedCategory == null || t.kategori == _selectedCategory;
      return cocokJenis && cocokCari && cocokKategori;
    }).toList();

    int compareByDate(Transactions a, Transactions b) {
      return _dateOrder == DateSortOrder.latest
          ? b.tanggal.compareTo(a.tanggal)
          : a.tanggal.compareTo(b.tanggal);
    }

    int compareByPrice(Transactions a, Transactions b) {
      if (_priceSort == null) return 0; // tidak berpengaruh kalau tidak aktif
      return _priceSort == PriceSortOrder.highest
          ? b.jumlah.compareTo(a.jumlah)
          : a.jumlah.compareTo(b.jumlah);
    }

    hasil.sort((a, b) {
      if (_sortPriority == _SortPriority.price && _priceSort != null) {
        final primary = compareByPrice(a, b);
        return primary != 0 ? primary : compareByDate(a, b);
      } else {
        final primary = compareByDate(a, b);
        return primary != 0 ? primary : compareByPrice(a, b);
      }
    });

    return hasil;
  }

  RelativeRect _menuPositionOf(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    return RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height + 4), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
  }

  Future<void> _showSortMenu(BuildContext context) async {
    final position = _menuPositionOf(context);

    final result = await showMenu<DateSortOrder>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(value: DateSortOrder.latest, child: Text('Terbaru')),
        PopupMenuItem(value: DateSortOrder.oldest, child: Text('Terlama')),
      ],
    );

    if (result != null) {
      setState(() {
        _dateOrder = result;
        _sortPriority = _SortPriority.date;
      });
    }
  }

  Future<void> _showPriceSortMenu(BuildContext context) async {
    final position = _menuPositionOf(context);

    final result = await showMenu<PriceSortOrder?>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(value: null, child: Text('Tidak diurutkan')),
        PopupMenuItem(value: PriceSortOrder.highest, child: Text('Harga Tertinggi')),
        PopupMenuItem(value: PriceSortOrder.lowest, child: Text('Harga Terendah')),
      ],
    );

    setState(() {
      _priceSort = result;
      _sortPriority = result != null ? _SortPriority.price : _SortPriority.date;
    });
  }

  Future<void> _showCategoriesMenu(BuildContext context) async {
    final position = _menuPositionOf(context);

    final result = await showMenu<String?>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(value: null, child: Text('Semua Kategori')),
        ...Transactions.categoriesOption.map(
          (k) => PopupMenuItem(value: k.id, child: Text(k.label)),
        ),
      ],
    );

    setState(() => _selectedCategory = result);
  }

  void _handleTypeSelected(String label) {
    setState(() {
      _selectedMasuk = switch (label) {
        'Masuk' => true,
        'Keluar' => false,
        _ => null,
      };
    });
  }

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
                            Builder(
                              builder: (context) => TransactionFilterDropdown(
                                label: _categoryLabel,
                                prefixIcon: Icons.filter_list,
                                onTap: () => _showCategoriesMenu(context),
                              ),
                            ),
                            Builder(
                              builder: (context) => TransactionFilterDropdown(
                                label: _sortLabel,
                                prefixIcon: Icons.calendar_today,
                                onTap: () => _showSortMenu(context),
                              ),
                            ),
                            Builder(
                              builder: (context) => TransactionFilterDropdown(
                                label: _priceSortLabel,
                                prefixIcon: Icons.swap_vert,
                                onTap: () => _showPriceSortMenu(context),
                              ),
                            ),
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
                ? const TransactionEmptyState()
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
                          mainAxisExtent: 72,
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