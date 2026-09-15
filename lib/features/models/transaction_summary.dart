import 'transactions.dart';

class TransactionSummary {
  final int totalMasuk;
  final int totalKeluar;
  final int jumlahTransaksi;

  const TransactionSummary({
    required this.totalMasuk,
    required this.totalKeluar,
    required this.jumlahTransaksi,
  });

  int get selisih => totalMasuk - totalKeluar;

  factory TransactionSummary.fromList(List<Transactions> list) {
    int masuk = 0;
    int keluar = 0;

    for (final t in list) {
      if (t.masuk) {
        masuk += t.jumlah;
      } else {
        keluar += t.jumlah;
      }
    }

    return TransactionSummary(
      totalMasuk: masuk,
      totalKeluar: keluar,
      jumlahTransaksi: list.length,
    );
  }
}