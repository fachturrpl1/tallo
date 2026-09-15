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

class DashboardPage extends StatelessWidget {
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

  List<Transactions> get _recentTransactions {
    final sorted = [...transactionsList]
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return sorted.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    final summary = TransactionSummary.fromList(transactionsList);
    final balanceResult = calculateBalance(transactionsList);
    final recentTransactions = _recentTransactions;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DashboardGreeting(
              userName: userName,
              isDarkMode: isDarkMode,
              onThemeToggle: onThemeToggle,
            ),
            const SizedBox(height: 16),
            TransactionSummaryBox(
              summary: summary,
              saldo: balanceResult.finalBalance,
            ),
            const SizedBox(height: 24),
            DashboardQuickActions(
              onTambahTap: () {}, // TODO: navigasi ke form tambah transaksi
              onKategoriTap: () {}, // TODO: navigasi ke halaman kategori
              onLaporanTap: () {}, // TODO: navigasi ke halaman laporan
              onLainnyaTap: () {}, // TODO: menu lainnya
            ),
            const SizedBox(height: 24),
            DashboardSectionHeader(
              title: 'Transaksi Terbaru',
              actionLabel: 'Lihat Semua',
              onActionTap: onViewAllTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionsPage(
                          transactionsList: transactionsList,
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