import 'category_option.dart';
import 'transaction_exceptions.dart';
import 'date.dart';

export 'date.dart';
export 'category_option.dart';

class Transactions {
  final String keterangan;
  final bool masuk;
  final String kategori;
  final int jumlah;
  final DateTime tanggal;

  Transactions({
    required this.keterangan,
    required this.masuk,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
  }) {
    if (jumlah <= 0) {
      throw InvalidJumlahException(jumlah);
    }
  }

  String get jenisLabel => masuk ? 'Masuk' : 'Keluar';

  /// Validasi kalender dan tahun kabisat via AppDate
  static DateTime inputTanggal(int dd, int mm, int yyyy) {
    return AppDate.parse(dd, mm, yyyy);
  }

  /// Tampilan tanggal, contoh: 7 Sep 2025
  String get tanggalFormatted => AppDate.formatMedium(tanggal);

  String get categoriesLabel {
    return categoriesOption
        .firstWhere(
          (c) => c.id == kategori,
          orElse: () => const CategoriesOption('', 'Kategori tidak ditemukan'),
        )
        .label;
  }
}