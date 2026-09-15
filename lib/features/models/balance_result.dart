import 'package:flutter/material.dart';
import 'transactions.dart';

class BalanceResult {
  final int finalBalance;
  final List<Transactions> transactionsOverBalance;

  const BalanceResult({
    required this.finalBalance,
    required this.transactionsOverBalance,
  });
}

BalanceResult calculateBalance(List<Transactions> transactionsList) {
  int balance = 0;
  final exceeded = <Transactions>[];

  final sorted = [...transactionsList]
    ..sort((a, b) => a.tanggal.compareTo(b.tanggal));

  for (final transaction in sorted) {
    if (transaction.masuk) {
      balance += transaction.jumlah;
    } else if (transaction.jumlah > balance) {
      exceeded.add(transaction);
    } else {
      balance -= transaction.jumlah;
    }
  }

  return BalanceResult(finalBalance: balance, transactionsOverBalance: exceeded);
}

/// Fungsi validasi saldo & pemanggil SnackBar merah yang terpusat di models
bool validateQuantityChange({
  required BuildContext context,
  required List<Transactions> simulatedList,
}) {
  final testResult = calculateBalance(simulatedList);

  if (testResult.finalBalance < 0 || testResult.transactionsOverBalance.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Peringatan: Saldo tidak boleh kurang dari atau sama dengan 0!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
    return false; // Tidak aman / melanggar batas
  }

  return true; // Aman
}