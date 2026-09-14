import 'package:flutter/material.dart';

class TransactionEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const TransactionEmptyState({
    super.key,
    this.title = 'Belum ada transaksi',
    this.subtitle =
        'Catat pemasukan atau pengeluaran pertama untuk mulai melihat arus uangmu.',
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final imagePath = isDark
        ? 'assets/empty_state_dark.png'
        : 'assets/empty_state_light.png';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 160,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}