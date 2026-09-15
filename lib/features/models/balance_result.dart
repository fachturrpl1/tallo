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