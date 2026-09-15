import 'package:flutter/material.dart';
import '../models/transactions.dart';
import '../models/transaction_summary.dart';
import '../models/balance_result.dart';
import '../widgets/dashboard/dashboard_greeting.dart';
import '../widgets/dashboard/dashboard_quick_actions.dart';
import '../widgets/dashboard/dashboard_section_header.dart';
import '../widgets/dashboard/transactions_summary.dart';
import '../widgets/transactions/card/transactions_card.dart';
import 'transaction_detail_page.dart';
import 'transactions_page.dart';

class DashboardPage extends StatelessWidget {
  final List<Transactions> transactionsList;
  final String userName;

  const DashboardPage({
    super.key,
    required this.transactionsList,
    this.userName = 'Fachtur',
  });

  List<Transactions> get _recentTransactions {
    final sorted = [...transactionsList]
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return sorted.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Ringkasan & saldo dihitung dari SELURUH data (bukan hasil filter),
    // karena dashboard menampilkan kondisi keuangan keseluruhan.
    final summary = TransactionSummary.fromList(transactionsList);
    final balanceResult = calculateBalance(transactionsList);
    final recentTransactions = _recentTransactions;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DashboardGreeting(
              userName: userName,
              onNotificationTap: () {}, // TODO: fitur notifikasi belum ada
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
              onActionTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TransactionsPage(transactionsList: transactionsList),
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