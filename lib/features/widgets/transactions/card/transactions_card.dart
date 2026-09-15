import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transactions.dart';
import '../../../presentation/transaction_presenter.dart';

class TransactionCard extends StatelessWidget {
  final Transactions transaction;
  final bool overBalance;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.overBalance = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat.decimalPattern('id_ID');

    final String amountPrefix = transaction.masuk ? '+Rp ' : '-Rp ';

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: transaction.categoryBgColor(context),
          child: Icon(
            transaction.icon,
            color: transaction.categoryColor(context),
            size: 20,
          ),
        ),
      title: Text(
        transaction.keterangan,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        '${transaction.tanggalFormatted} • ${transaction.categoriesLabel}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
        trailing: Text(
          '$amountPrefix${currencyFormat.format(transaction.jumlah)}',
          style: TextStyle(
            color: transaction.amountColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}