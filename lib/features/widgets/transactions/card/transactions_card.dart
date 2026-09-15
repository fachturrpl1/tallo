import 'package:flutter/material.dart';
import 'package:tallo/features/presentation/transaction_presenter.dart';
import '../../../models/transactions.dart';

class TransactionCard extends StatelessWidget {
  final Transactions transaction;
  final bool overBalance;
  final int currentQuantity; // <-- Tambahan parameter kuantitas
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.overBalance = false,
    this.currentQuantity = 1, // <-- Nilai default
    this.onQuantityChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: transaction.categoryBgColor(context),
              child: Icon(
                transaction.icon,
                size: 18,
                color: transaction.categoryColor(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.keterangan,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.tanggalFormatted,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${transaction.masuk ? '+Rp ' : '-Rp '}${transaction.jumlah * currentQuantity}', // Nominal dikalikan jumlah
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: transaction.masuk ? Colors.green : colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      iconSize: 18,
                      color: colorScheme.onSurfaceVariant,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onTap,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Stepper Fungsional
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: currentQuantity > 1
                          ? () => onQuantityChanged?.call(currentQuantity - 1)
                          : null,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withAlpha(100),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 14,
                          color: currentQuantity > 1 ? colorScheme.primary : colorScheme.onSurface.withAlpha(60),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '$currentQuantity',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () => onQuantityChanged?.call(currentQuantity + 1),
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withAlpha(100),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(Icons.add, size: 14, color: colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}