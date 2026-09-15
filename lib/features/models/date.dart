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

  /// Mengecek apakah suatu tahun adalah tahun kabisat.
  static bool isLeapYear(int yyyy) {
    // kelipatan 4 dan (bukan abad ATAU kelipatan 400)
    return (yyyy % 4 == 0 && yyyy % 100 != 0) || (yyyy % 400 == 0);
  }

  /// Parsing string tanggal dengan format 'd/M/yyyy' atau ISO 'yyyy-MM-dd'.
  static DateTime? tryParseString(String dateStr) {
    final parts = dateStr.trim().split('/');
    if (parts.length == 3) {
      final dd = int.tryParse(parts[0]);
      final mm = int.tryParse(parts[1]);
      final yyyy = int.tryParse(parts[2]);
      if (dd != null && mm != null && yyyy != null) {
        return tryParse(dd, mm, yyyy);
      }
    }
    try {
      final dt = DateTime.parse(dateStr.trim());
      if (isValid(dt.day, dt.month, dt.year)) {
        return DateTime(dt.year, dt.month, dt.day);
      }
    } catch (_) {}
    return null;
  }

  static DateTime parseString(String dateStr) {
    final result = tryParseString(dateStr);
    if (result == null) {
      throw FormatException('Tanggal tidak valid: $dateStr');
    }
    return result;
  }

  static int _daysInMonth(int mm, int yyyy) {
    if (mm == 2) {
      return isLeapYear(yyyy) ? 29 : 28;
    }
    const bulan30Hari = {4, 6, 9, 11};
    return bulan30Hari.contains(mm) ? 30 : 31;
  }
}