import 'package:flutter/material.dart';
import 'package:tallo/features/pages/splashscreen.dart';
import 'features/models/transactions.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const TalloApp());
}

final List<Transactions> transactionsList = [
  Transactions(
    keterangan: 'Penjualan hari senin',
    masuk: true,
    kategori: '1',
    jumlah: 350000,
    tanggal: Transactions.inputTanggal(10, 9, 2026),
  ),
  Transactions(
    keterangan: 'Gaji Bulanan',
    masuk: true,
    kategori: '3',
    jumlah: 5000000,
    tanggal: Transactions.inputTanggal(11, 9, 2026),
  ),
  Transactions(
    keterangan: 'Belanja Bahan Makanan',
    masuk: false,
    kategori: '2',
    jumlah: 150000,
    tanggal: Transactions.inputTanggal(12, 9, 2026),
  ),
  Transactions(
    keterangan: 'Penjualan hari selasa',
    masuk: false,
    kategori: '1',
    jumlah: 400000,
    tanggal: Transactions.inputTanggal(13, 9, 2026),
  ),
  Transactions(
    keterangan: 'Belanja Bahan Makanan',
    masuk: false,
    kategori: '2',
    jumlah: 200000,
    tanggal: Transactions.inputTanggal(14, 9, 2026),
  ),

  Transactions(
    keterangan: 'Gaji Bulanan',
    masuk: true,
    kategori: '3',
    jumlah: 5000000,
    tanggal: Transactions.inputTanggal(15, 9, 2026),
  ),

  Transactions(
    keterangan: 'Belanja Bahan Makanan',
    masuk: false,
    kategori: '2',
    jumlah: 250000,
    tanggal: Transactions.inputTanggal(16, 9, 2026),
  ),

  Transactions(
    keterangan: 'Penjualan hari rabu',
    masuk: false,
    kategori: '1',
    jumlah: 450000,
    tanggal: Transactions.inputTanggal(17, 9, 2026),
  ),
];

class TalloApp extends StatelessWidget {
  const TalloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: SplashScreen(transactionsList: transactionsList),
    );
  }
}