import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tallo/features/models/transactions.dart';
import 'package:tallo/features/models/transaction_sort.dart';
import 'package:tallo/features/pages/transactions_page.dart';
import 'package:tallo/features/models/date.dart';
import 'package:tallo/core/theme/app_theme.dart';

void main() {
  testWidgets('TransactionsPage renders correctly and displays transactions', (WidgetTester tester) async {
    final transactions = [
      Transactions(
        keterangan: 'Penjualan A',
        masuk: true,
        kategori: '1',
        jumlah: 100000,
        tanggal: Transactions.inputTanggal(10, 9, 2026),
      ),
      Transactions(
        keterangan: 'Belanja B',
        masuk: false,
        kategori: '2',
        jumlah: 50000,
        tanggal: Transactions.inputTanggal(11, 9, 2026),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: TransactionsPage(transactionsList: transactions),
      ),
    );

    expect(find.text('Transaksi'), findsOneWidget);
    expect(find.text('Penjualan A'), findsOneWidget);
    expect(find.text('Belanja B'), findsOneWidget);
    expect(find.text('Terbaru'), findsOneWidget);
    expect(find.text('Harga'), findsOneWidget);
  });

  test('Transaction sort models have proper labels and values', () {
    expect(DateSortOrder.latest.label, 'Terbaru');
    expect(DateSortOrder.oldest.label, 'Terlama');
    expect(PriceSortOrder.highest.label, 'Tertinggi');
    expect(PriceSortOrder.lowest.label, 'Terendah');
    expect(SortPriority.values, contains(SortPriority.date));
    expect(SortPriority.values, contains(SortPriority.price));
  });

  group('AppDate - Validasi Kabisat & Non-Kabisat', () {
    test('Tahun kabisat vs non-kabisat dikenali dengan benar', () {
      expect(AppDate.isLeapYear(2024), isTrue); // kelipatan 4
      expect(AppDate.isLeapYear(2025), isFalse); // bukan kelipatan 4
      expect(AppDate.isLeapYear(2000), isTrue); // kelipatan 400
      expect(AppDate.isLeapYear(1900), isFalse); // abad bukan kelipatan 400
    });

    test('Tanggal 29 Februari valid pada tahun kabisat dan invalid pada non-kabisat', () {
      expect(AppDate.isValid(29, 2, 2024), isTrue);
      expect(AppDate.isValid(29, 2, 2025), isFalse);
      expect(AppDate.isValid(28, 2, 2025), isTrue);
      expect(AppDate.isValid(30, 2, 2024), isFalse);

      expect(AppDate.tryParse(29, 2, 2024), equals(DateTime(2024, 2, 29)));
      expect(AppDate.tryParse(29, 2, 2025), isNull);
      expect(() => AppDate.parse(29, 2, 2025), throwsA(isA<FormatException>()));
    });

    test('AppDate.tryParseString dan parseString memvalidasi kabisat', () {
      expect(AppDate.tryParseString('29/2/2024'), equals(DateTime(2024, 2, 29)));
      expect(AppDate.tryParseString('29/2/2025'), isNull);
      expect(AppDate.parseString('28/2/2025'), equals(DateTime(2025, 2, 28)));
    });

    test('Perbandingan tanggal secara kronologis akurat dengan DateTime', () {
      final tKabisat = Transactions.inputTanggal(29, 2, 2024);
      final tMaret = Transactions.inputTanggal(1, 3, 2024);
      final tSept2 = Transactions.inputTanggal(2, 9, 2026);
      final tSept15 = Transactions.inputTanggal(15, 9, 2026);

      // 29 Feb 2024 lebih lampau dari 1 Maret 2024
      expect(tKabisat.isBefore(tMaret), isTrue);

      // 2 Sept 2026 lebih lampau dari 15 Sept 2026 (kronologis benar, tidak seperti String "2" > "1")
      expect(tSept2.isBefore(tSept15), isTrue);
      expect(tSept15.compareTo(tSept2), greaterThan(0));
    });
  });
}
