import 'package:intl/intl.dart';

/// Utility untuk validasi dan format tanggal transaksi.
class AppDate {
  AppDate._(); // tidak perlu diinstansiasi, semua method static

  /// Mengecek apakah kombinasi hari/bulan/tahun valid secara kalender.
  static bool isValid(int dd, int mm, int yyyy) {
    if (mm < 1 || mm > 12) return false;
    if (dd < 1 || dd > _daysInMonth(mm, yyyy)) return false;
    return true;
  }

  /// Mengembalikan DateTime jika valid, null jika tidak.
  /// Kode pemanggil WAJIB cek null sebelum pakai, tidak ada nilai
  /// "error sebagai string" yang bisa kebawa tanpa sengaja.
  static DateTime? tryParse(int dd, int mm, int yyyy) {
    if (!isValid(dd, mm, yyyy)) return null;
    return DateTime(yyyy, mm, dd);
  }

  /// Sama seperti tryParse, tapi melempar exception kalau tidak valid.
  /// Cocok dipakai saat kamu yakin input sudah pasti benar
  /// (misal hasil dari date picker Flutter, bukan input manual).
  static DateTime parse(int dd, int mm, int yyyy) {
    final result = tryParse(dd, mm, yyyy);
    if (result == null) {
      throw FormatException('Tanggal tidak valid: $dd/$mm/$yyyy');
    }
    return result;
  }

  /// Format tampilan singkat, contoh: 7/9/2025
  static String formatShort(DateTime date) {
    return DateFormat('d/M/yyyy').format(date);
  }

  /// Format tampilan panjang sesuai mockup, contoh: 7 Sep 2025
  static String formatMedium(DateTime date, {String locale = 'id'}) {
    return DateFormat('d MMM yyyy', locale).format(date);
  }

  /// Format lengkap dengan jam, contoh: 7 Sep 2025, 09:24
  static String formatWithTime(DateTime date, {String locale = 'id'}) {
    return DateFormat('d MMM yyyy, HH:mm', locale).format(date);
  }

  static int _daysInMonth(int mm, int yyyy) {
    if (mm == 2) {
      return _isLeapYear(yyyy) ? 29 : 28;
    }
    const bulan30Hari = {4, 6, 9, 11};
    return bulan30Hari.contains(mm) ? 30 : 31;
  }

  static bool _isLeapYear(int yyyy) {
    // kelipatan 4 dan (bukan abad ATAU kelipatan 400)
    return (yyyy % 4 == 0 && yyyy % 100 != 0) || (yyyy % 400 == 0);
  }
}