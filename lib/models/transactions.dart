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
}

// switchcase kategori
String kategoriLabel(String kode) {
  switch (kode) {
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

int hitungSaldo(List<Transactions> daftarTransaksi) {
  int saldo = 0;

  for (Transactions transaksi in daftarTransaksi) {
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