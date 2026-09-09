import 'package:flutter/material.dart';

class Transaksi {
  final String keterangan;
  final String jenis;
  final String kategori;
  final int jumlah;
  final String tanggal;

  Transaksi({
    required this.keterangan,
    required this.jenis,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
  });

  // static berguna mengubah kepemilikan method menjadi milik class bukan milik object
  static String inputTanggal(int dd, int mm, int yyyy) {
    if (mm < 1 || mm > 12) {
      return 'Bulan tidak valid';
    }

    int maxHari = 31;

    if (mm == 2) {
      // Cek apakah tahun kabisat
      bool isKabisat = (
        // kelipatan 4 (kabisat)
        yyyy % 4 == 0 && 
        // abad bukan kabisat kecuali kelipatan 400
        yyyy % 100 != 0
        ) || (
        // kelipatan 400 (kabisat)
        yyyy % 400 == 0
        );
      maxHari = isKabisat ? 29 : 28;
    } else if (mm == 4 || mm == 6 || mm == 9 || mm == 11) {
      maxHari = 30;
    }
    if (dd < 1 || dd > maxHari) {
      return 'Tanggal tidak valid untuk bulan dan tahun ini';
    }
    return '$dd/$mm/$yyyy';
  }
}

String cekMasuk(bool masuk) {
  if (masuk) {
    return 'Masuk';
  } else {
    return 'Keluar';
  }
}

// switchcase kategori
String kategori(String kategori) {
  switch(kategori) {
    case '1':
      return 'Penjualan';
    case '2':
      return 'Belanja';
    case '3':
      return 'Operasional';
    default:
      return 'Kategori tidak valid';
  }
}

int HitungSaldo(List<Transaksi> daftarTransaksi) {
  int saldo = 0;

  // 1. Saldo dihitung dengan perulangan: seluruh pemasukan dijumlahkan, seluruh pengeluaran dikurangkan.
  for (Transaksi transaksi in daftarTransaksi) {

    // 3. Jumlah transaksi tidak boleh 0 atau negatif.
    if (transaksi.jumlah <= 0) {
      print('jumlah tidak valid');
    }

    if (transaksi.jenis == true) {
      saldo += transaksi.jumlah;
    } else 
     
    if (transaksi.jenis == false) {
      // 2. Transaksi keluar yang melebihi saldo saat itu harus ditandai sebagai "melebihi saldo".
      if (transaksi.jumlah > saldo) {
        print('melebihi saldo');
      } else {
        saldo -= transaksi.jumlah;
      }
    }
  }
  return saldo;
}

void main() {
  runApp(const MyApp());

  List<Transaksi> daftarTransaksi = [
    Transaksi(
      keterangan: 'Penjualan hari senin',
      jenis: cekMasuk(true),
      kategori: kategori('1'),
      jumlah: 350000,
      tanggal: Transaksi.inputTanggal(10, 9, 2026),
    ),
    Transaksi(
      keterangan: 'Gaji Bulanan',
      jenis: cekMasuk(true),
      kategori: kategori('3'),
      jumlah: 5000000,
      tanggal: Transaksi.inputTanggal(11, 9, 2026),
    ),

    Transaksi(
      keterangan: 'Belanja Bahan Makanan',
      jenis: cekMasuk(false),
      kategori: kategori('2'),
      jumlah: 150000,
      tanggal: Transaksi.inputTanggal(12, 9, 2026),
    ),
    Transaksi(
      keterangan: 'Penjualan hari selasa',
      jenis: cekMasuk(false),
      kategori: kategori('1'),
      jumlah: 400000,
      tanggal: Transaksi.inputTanggal(13, 9, 2026),
    ),
    Transaksi(
      keterangan: 'Belanja Bahan Makanan',
      jenis: cekMasuk(false),
      kategori: kategori('2'),
      jumlah: 200000,
      tanggal: Transaksi.inputTanggal(14, 9, 2026),
    ),

    Transaksi(
      keterangan: 'Gaji Bulanan',
      jenis: cekMasuk(true),
      kategori: kategori('3'),
      jumlah: 5000000,
      tanggal: Transaksi.inputTanggal(15, 9, 2026),
    ),

    Transaksi(
      keterangan: 'Belanja Bahan Makanan',
      jenis: cekMasuk(false),
      kategori: kategori('2'),
      jumlah: 250000,
      tanggal: Transaksi.inputTanggal(16, 9, 2026),
    ),

    Transaksi(
      keterangan: 'Penjualan hari rabu',
      jenis: cekMasuk(false),
      kategori: kategori('1'),
      jumlah: 450000,
      tanggal: Transaksi.inputTanggal(17, 9, 2026),
    ),
  ];

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buku Kas',
    );
  }
}
