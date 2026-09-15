import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_summary.dart';

class TransactionSummaryBox extends StatelessWidget {
  final TransactionSummary summary;
  final int? saldo;

  const TransactionSummaryBox({
    super.key,
    required this.summary,
    this.saldo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat.decimalPattern('id_ID');
    final bool showSaldo = saldo != null; // tambahan

    Widget pill({
      required IconData icon,
      required String label,
      required int value,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Icon(icon, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    Text(
                      'Rp ${currencyFormat.format(value)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showSaldo) ...[
            const Text('Saldo Saat Ini', style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              'Rp ${currencyFormat.format(saldo)}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              pill(icon: Icons.arrow_downward, label: 'Masuk', value: summary.totalMasuk),
              const SizedBox(width: 12),
              pill(icon: Icons.arrow_upward, label: 'Keluar', value: summary.totalKeluar),
            ],
          ),
        ],
      ),
    );
  }
}