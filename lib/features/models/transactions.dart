import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CategoriesOption {
  final String id;
  final String label;

  const CategoriesOption(
    this. id,
    this.label,
  );
}

class Transactions {
  final String keterangan;
  final bool masuk;        // diganti ke bool, lebih tepat untuk dibandingkan sebagai jenis transaksi
  final String kategori;
  final int jumlah;
  final String tanggal;

  Transactions({
    required this.keterangan,
    required this.masuk,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
  });

  static const List<CategoriesOption> categoriesOption = [
    CategoriesOption('1', 'Penjualan'),
    CategoriesOption('2', 'Belanja'),
    CategoriesOption('3', 'Operasional'),
  ];

  String get jenisLabel => masuk ? 'Masuk' : 'Keluar';

  static String inputTanggal(int dd, int mm, int yyyy) {
    if (mm < 1 || mm > 12) {
      return 'Bulan tidak valid';
    }

    int maxHari = 31;

    if (mm == 2) {
      bool isKabisat =
          (yyyy % 4 == 0 && yyyy % 100 != 0) || (yyyy % 400 == 0);
      maxHari = isKabisat ? 29 : 28;
    } else if (mm == 4 || mm == 6 || mm == 9 || mm == 11) {
      maxHari = 30;
    }
    if (dd < 1 || dd > maxHari) {
      return 'Tanggal tidak valid untuk bulan dan tahun ini';
    }
    return '$dd/$mm/$yyyy';
  }
  // switchcase kategori
  String get categoriesLabel {
    return categoriesOption.firstWhere(
      (c) => c.id == kategori,
      orElse: () => const CategoriesOption('','Kategori tidak ditemukan')
    ).label;
  }

  // 2. Ikon Kategori murni berdasarkan kodeKategori
  IconData get icon {
    switch (kategori) {
      case '1':
        return Icons.point_of_sale_rounded;
      case '2':
        return Icons.shopping_bag_outlined;
      case '3':
        return Icons.business_center_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  // 3. Warna Ikon murni berdasarkan kodeKategori (Tidak peduli masuk/keluar)
  Color categoryColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final colorScheme = Theme.of(context).colorScheme;
    switch (kategori) {
      case '1':
        return appColors.green;
      case '2':
        return appColors.red;
      case '3':
        return appColors.blue;
      default:
        return colorScheme.primary;
    }
  }

  // 4. Warna Background Ikon murni berdasarkan kodeKategori
  Color categoryBgColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;
    switch (kategori) {
      case '1':
        return appColors.greenBg;
      case '2':
        return appColors.redBg;
      case '3':
        return appColors.blueBg;
      default:
        return colorScheme.tertiary;
    }
  }

  // 5. Warna khusus nominal Uang (Satu-satunya yang masih bergantung pada jenis transaksi)
  Color amountColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return masuk ? appColors.green : appColors.red;
  }
}

int hitungSaldo(List<Transactions> transactionsList) {
  int saldo = 0;

  for (Transactions transaksi in transactionsList) {
    if (transaksi.jumlah <= 0) {
      print('jumlah tidak valid');
      continue;
    }

    if (transaksi.masuk) {
      saldo += transaksi.jumlah;
    } else {
      if (transaksi.jumlah > saldo) {
        print('melebihi saldo');
      } else {
        saldo -= transaksi.jumlah;
      }
    }
  }
  return saldo;
}