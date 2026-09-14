import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tallo/core/theme/app_theme.dart';
import 'package:tallo/features/models/transactions.dart';
import 'package:tallo/features/models/transaction_sort.dart';
import 'package:tallo/features/pages/transactions_page.dart';

void main() {
  testWidgets('TransactionsPage renders correctly and displays transactions', (WidgetTester tester) async {
    final transactions = [
      Transactions(
        keterangan: 'Penjualan A',
        masuk: true,
        kategori: '1',
        jumlah: 100000,
        tanggal: '10/9/2026',
      ),
      Transactions(
        keterangan: 'Belanja B',
        masuk: false,
        kategori: '2',
        jumlah: 50000,
        tanggal: '11/9/2026',
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
}
