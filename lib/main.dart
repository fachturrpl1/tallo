import 'package:flutter/material.dart';
import 'features/models/transactions.dart';
import 'features/pages/transactions_page.dart';

void main() {
  runApp(const MyApp());
}

final List<Transactions> transactionsList = [
  Transactions(
    keterangan: 'Penjualan hari senin',
    masuk: true,
    kategori: kategoriLabel('1'),
    jumlah: 350000,
    tanggal: Transactions.inputTanggal(10, 9, 2026),
  ),
  Transactions(
    keterangan: 'Gaji Bulanan',
    masuk: true,
    kategori: kategoriLabel('3'),
    jumlah: 5000000,
    tanggal: Transactions.inputTanggal(11, 9, 2026),
  ),
  Transactions(
    keterangan: 'Belanja Bahan Makanan',
    masuk: false,
    kategori: kategoriLabel('2'),
    jumlah: 150000,
    tanggal: Transactions.inputTanggal(12, 9, 2026),
  ),
  Transactions(
    keterangan: 'Penjualan hari selasa',
    masuk: false,
    kategori: kategoriLabel('1'),
    jumlah: 400000,
    tanggal: Transactions.inputTanggal(13, 9, 2026),
  ),
  Transactions(
    keterangan: 'Belanja Bahan Makanan',
    masuk: false,
    kategori: kategoriLabel('2'),
    jumlah: 200000,
    tanggal: Transactions.inputTanggal(14, 9, 2026),
  ),

  Transactions(
    keterangan: 'Gaji Bulanan',
    masuk: true,
    kategori: kategoriLabel('3'),
    jumlah: 5000000,
    tanggal: Transactions.inputTanggal(15, 9, 2026),
  ),

  Transactions(
    keterangan: 'Belanja Bahan Makanan',
    masuk: false,
    kategori: kategoriLabel('2'),
    jumlah: 250000,
    tanggal: Transactions.inputTanggal(16, 9, 2026),
  ),

  Transactions(
    keterangan: 'Penjualan hari rabu',
    masuk: false,
    kategori: kategoriLabel('1'),
    jumlah: 450000,
    tanggal: Transactions.inputTanggal(17, 9, 2026),
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TransactionPage(TransactionsList: transactionsList),
    );
  }
}