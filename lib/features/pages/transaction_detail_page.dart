import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transactions.dart';

class TransactionDetailPage extends StatelessWidget {
  final Transactions transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat.decimalPattern('id_ID');
    final String amountPrefix = transaction.masuk ? '+Rp ' : '-Rp ';

    Widget infoRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant)),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: transaction.categoryBgColor(context),
              child: Icon(transaction.icon, color: transaction.categoryColor(context)),
            ),
            const SizedBox(height: 16),
            Text(
              transaction.keterangan,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transaction.tanggalFormatted,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Text(
              '$amountPrefix${currencyFormat.format(transaction.jumlah)}',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: transaction.amountColor(context),
              ),
            ),
            Divider(height: 32, color: colorScheme.outlineVariant),
            infoRow('Label', transaction.keterangan),
            Divider(height: 1, color: colorScheme.outlineVariant),
            infoRow('Kategori', transaction.categoriesLabel),
            Divider(height: 1, color: colorScheme.outlineVariant),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.outlineVariant),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}