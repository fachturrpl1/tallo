import 'package:flutter/material.dart';
import 'package:tallo/features/widgets/transactions/transaction_emptystate.dart';
import '../widgets/transactions/transaction_search_bar.dart';
import '../widgets/transactions/transaction_category_filter.dart';
import '../widgets/transactions/dropdown/transaction_dropdown_filter.dart';
import '../widgets/transactions/card/transactions_card.dart';
import '../models/transactions.dart';
import '../models/transaction_sort.dart';

import '../models/balance_result.dart';
import '../models/transaction_summary.dart';
import '../widgets/dashboard/transactions_summary.dart';

import 'transaction_detail_page.dart';

class TransactionsPage extends StatefulWidget {
  final List<Transactions> transactionsList;

  const TransactionsPage({super.key, required this.transactionsList});

  @override
  State<TransactionsPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();

  bool? _selectedMasuk;
  String _searchQuery = '';

  DateSortOrder _dateOrder = DateSortOrder.latest;
  PriceSortOrder? _priceSort;
  SortPriority _sortPriority = SortPriority.date;

  String? _selectedCategory;

  // Key menggunakan indeks posisi transaksi asli agar tidak terjadi instance mismatch
  final Map<int, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    _initQuantities();
  }

  @override
  void didUpdateWidget(covariant TransactionsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactionsList != widget.transactionsList) {
      _initQuantities();
    }
  }

  void _initQuantities() {
    _quantities.clear();
    for (int i = 0; i < widget.transactionsList.length; i++) {
      _quantities[i] = 1;
    }
  }

  void _handleQuantityChanged(int originalIndex, int newQty) {
    setState(() {
      _quantities[originalIndex] = newQty;
    });
  }

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
    return categoriesOption
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

  // Menyimpan struktur transaksi beserta referensi indeks aslinya
  List<({int originalIndex, Transactions transaction})> get _calculatedWithIndex {
    final list = <({int originalIndex, Transactions transaction})>[];
    for (int i = 0; i < widget.transactionsList.length; i++) {
      final item = widget.transactionsList[i];
      final qty = _quantities[i] ?? 1;
      final calculatedItem = Transactions(
        keterangan: item.keterangan,
        masuk: item.masuk,
        kategori: item.kategori,
        jumlah: item.jumlah * qty,
        tanggal: item.tanggal,
      );
      list.add((originalIndex: i, transaction: calculatedItem));
    }
    return list;
  }

  List<({int originalIndex, Transactions transaction})> get _filterResult {
    final result = _calculatedWithIndex.where((entry) {
      final t = entry.transaction;
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
      if (_priceSort == null) return 0;
      return _priceSort == PriceSortOrder.highest
          ? b.jumlah.compareTo(a.jumlah)
          : a.jumlah.compareTo(b.jumlah);
    }

    result.sort((entryA, entryB) {
      final a = entryA.transaction;
      final b = entryB.transaction;
      if (_sortPriority == SortPriority.price && _priceSort != null) {
        final primary = compareByPrice(a, b);
        return primary != 0 ? primary : compareByDate(a, b);
      } else {
        final primary = compareByDate(a, b);
        return primary != 0 ? primary : compareByPrice(a, b);
      }
    });

    return result;
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
        _sortPriority = SortPriority.date;
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
      _sortPriority = result != null ? SortPriority.price : SortPriority.date;
    });
  }

  Future<void> _showCategoriesMenu(BuildContext context) async {
    final position = _menuPositionOf(context);

    final result = await showMenu<String?>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(value: null, child: Text('Semua Kategori')),
        ...categoriesOption.map(
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
    final filteredEntries = _filterResult;
    final filteredList = filteredEntries.map((e) => e.transaction).toList();
    final allCalculatedList = _calculatedWithIndex.map((e) => e.transaction).toList();

    final summary = TransactionSummary.fromList(filteredList);
    final balanceResult = calculateBalance(allCalculatedList);

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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TransactionSummaryBox(
              summary: summary,
              saldo: balanceResult.finalBalance,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final contentWidth = constraints.maxWidth;
                final searchWidth = contentWidth < 600 ? contentWidth : 715.0;
                final isNarrow = contentWidth < 600;

                final allFilters = [
                  TransactionCategoryFilter(
                    types: const ['Semua', 'Masuk', 'Keluar'],
                    selectedType: _selectedTypeLabel,
                    onTypeSelected: _handleTypeSelected,
                  ),
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
                ];

                Widget filterBar = isNarrow
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < allFilters.length; i++) ...[
                              allFilters[i],
                              if (i != allFilters.length - 1)
                                const SizedBox(width: 12),
                            ],
                          ],
                        ),
                      )
                    : Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: allFilters,
                      );

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
                    isNarrow
                        ? SizedBox(width: contentWidth, child: filterBar)
                        : filterBar,
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: filteredEntries.isEmpty
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
                        itemCount: filteredEntries.length,
                        padding: const EdgeInsets.only(
                            bottom: 8, left: 8, right: 8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: kolom,
                          mainAxisExtent: 72,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          final entry = filteredEntries[index];

                          return TransactionCard(
                            key: ValueKey('tx_${entry.originalIndex}'),
                            transaction: entry.transaction,
                            overBalance:
                                balanceResult.transactionsOverBalance.contains(entry.transaction),
                            onQuantityChanged: (qty) =>
                                _handleQuantityChanged(entry.originalIndex, qty),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TransactionDetailPage(transaction: entry.transaction),
                                ),
                              );
                            },
                          );
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