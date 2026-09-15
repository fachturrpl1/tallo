import 'package:flutter/material.dart';
import 'package:tallo/features/pages/transactions_page.dart';
import '../models/transactions.dart';
import '../models/transaction_summary.dart';
import '../models/balance_result.dart';
import '../widgets/dashboard/dashboard_greeting.dart';
import '../widgets/dashboard/dashboard_quick_actions.dart';
import '../widgets/dashboard/dashboard_section_header.dart';
import '../widgets/dashboard/transactions_summary.dart';
import '../widgets/transactions/card/transactions_card.dart';
import 'transaction_detail_page.dart';

class DashboardPage extends StatefulWidget {
  final List<Transactions> transactionsList;
  final String userName;
  final bool isDarkMode;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onViewAllTap;

  const DashboardPage({
    super.key,
    required this.transactionsList,
    this.userName = 'Andi',
    required this.isDarkMode,
    this.onThemeToggle,
    this.onViewAllTap,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Map<Transactions, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    _initQuantities();
  }

  @override
  void didUpdateWidget(covariant DashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactionsList != widget.transactionsList) {
      _initQuantities();
    }
  }

  void _initQuantities() {
    for (var item in widget.transactionsList) {
      _quantities.putIfAbsent(item, () => 1);
    }
  }

  List<Transactions> get _calculatedTransactions {
    return widget.transactionsList.map((item) {
      final qty = _quantities[item] ?? 1;
      return Transactions(
        keterangan: item.keterangan,
        masuk: item.masuk,
        kategori: item.kategori,
        jumlah: item.jumlah * qty,
        tanggal: item.tanggal,
      );
    }).toList();
  }

  List<Transactions> get _recentTransactions {
    final sorted = [...widget.transactionsList]
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return sorted.take(4).toList();
  }

  void _handleQuantityChanged(Transactions item, int newQty) {
    final tempQuantities = Map<Transactions, int>.from(_quantities);
    tempQuantities[item] = newQty;

    final testList = widget.transactionsList.map((tx) {
      final qty = tempQuantities[tx] ?? 1;
      return Transactions(
        keterangan: tx.keterangan,
        masuk: tx.masuk,
        kategori: tx.kategori,
        jumlah: tx.jumlah * qty,
        tanggal: tx.tanggal,
      );
    }).toList();

    // Memanggil fungsi validasi dari models
    bool isValid = validateQuantityChange(context: context, simulatedList: testList);

    if (isValid) {
      setState(() {
        _quantities[item] = newQty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final computedList = _calculatedTransactions;
    final summary = TransactionSummary.fromList(computedList);
    final balanceResult = calculateBalance(computedList);
    final recentTransactions = _recentTransactions;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DashboardGreeting(
              userName: widget.userName,
              isDarkMode: widget.isDarkMode,
              onThemeToggle: widget.onThemeToggle,
            ),
            const SizedBox(height: 16),
            TransactionSummaryBox(
              summary: summary,
              saldo: balanceResult.finalBalance,
            ),
            const SizedBox(height: 24),
            DashboardQuickActions(
              onTambahTap: () {},
              onKategoriTap: () {},
              onLaporanTap: () {},
              onLainnyaTap: () {},
            ),
            const SizedBox(height: 24),
            DashboardSectionHeader(
              title: 'Transaksi Terbaru',
              actionLabel: 'Lihat Semua',
              onActionTap: widget.onViewAllTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionsPage(
                          transactionsList: widget.transactionsList,
                        ),
                      ),
                    );
                  },
            ),
            const SizedBox(height: 8),
            ...recentTransactions.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TransactionCard(
                  transaction: item,
                  overBalance:
                      balanceResult.transactionsOverBalance.contains(item),
                  currentQuantity: _quantities[item] ?? 1,
                  onQuantityChanged: (qty) => _handleQuantityChanged(item, qty),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TransactionDetailPage(transaction: item),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}