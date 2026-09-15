import 'package:flutter/material.dart';
import 'features/pages/splashscreen.dart';
import 'features/models/transactions.dart';
import 'core/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id',null);
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
    jumlah: 300000,
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

class TalloApp extends StatefulWidget {
  const TalloApp({super.key});

  @override
  State<TalloApp> createState() => _TalloAppState();
}

class _TalloAppState extends State<TalloApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: SplashScreen(
        transactionsList: transactionsList,
        isDarkMode: _themeMode == ThemeMode.dark, // tambahan
        onThemeToggle: _toggleTheme, // tambahan
      ),
    );
  }
}