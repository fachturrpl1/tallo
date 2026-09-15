// import 'package:flutter/material.dart';
// import '../models/transactions.dart';
// import '../widgets/navigation/app_bottom_nav.dart';
// import 'dashboard_page.dart';
// import 'transactions_page.dart';

// class RootShell extends StatefulWidget {
//   final List<Transactions> transactionsList;
//   final bool isDarkMode;
//   final VoidCallback? onThemeToggle;

//   const RootShell({
//     super.key,
//     required this.transactionsList,
//     required this.isDarkMode,
//     this.onThemeToggle,
//   });

//   @override
//   State<RootShell> createState() => _RootShellState();
// }

// class _RootShellState extends State<RootShell> {
//   int _currentTab = 0; // satu-satunya sumber kebenaran untuk tab aktif

//   void _handleTabSelected(int index) {
//     // index 2 = tombol "+", tidak punya halaman sendiri — ditangani terpisah
//     if (index == 2) return;
//     setState(() => _currentTab = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       DashboardPage(
//         transactionsList: widget.transactionsList,
//         isDarkMode: widget.isDarkMode,
//         onThemeToggle: widget.onThemeToggle,
//       ),
//       TransactionsPage(transactionsList: widget.transactionsList),
//       const SizedBox.shrink(), // placeholder untuk Kategori (belum ada halaman)
//       const SizedBox.shrink(), // placeholder untuk Akun (belum ada halaman)
//     ];

//     return Scaffold(
//       body: IndexedStack(
//         index: _tabToPageIndex(_currentTab),
//         children: pages,
//       ),
//       bottomNavigationBar: AppBottomNav(
//         currentIndex: _currentTab,
//         onTabSelected: _handleTabSelected,
//         onAddTap: () {}, // TODO: navigasi ke form tambah transaksi
//       ),
//     );
//   }

//   // AppBottomNav punya 5 slot visual (index 0,1,2,3,4 termasuk tombol +),
//   // tapi cuma 4 halaman nyata. Fungsi ini memetakan index navbar -> index page.
//   int _tabToPageIndex(int navIndex) {
//     switch (navIndex) {
//       case 0:
//         return 0; // Beranda
//       case 1:
//         return 1; // Transaksi
//       case 3:
//         return 2; // Kategori
//       case 4:
//         return 3; // Akun
//       default:
//         return 0;
//     }
//   }
// }