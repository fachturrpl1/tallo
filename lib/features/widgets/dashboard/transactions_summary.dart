import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../models/transaction_summary.dart';

class TransactionSummaryBox extends StatelessWidget {
  final TransactionSummary summary;

  const TransactionSummaryBox({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppColors>() ??
        (isDark ? AppColors.dark : AppColors.light);

    final currencyFormat = NumberFormat.decimalPattern('id_ID');

    Widget buildPill({
      required IconData icon,
      required String label,
      required int value,
      required Color iconColor,
      required Color iconBgColor,
      required Color textColor,
    }) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: iconBgColor,
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Rp ${currencyFormat.format(value)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final items = [
      buildPill(
        icon: Icons.arrow_downward_rounded,
        label: 'Masuk',
        value: summary.totalMasuk,
        iconColor: appColors.green,
        iconBgColor: appColors.greenBg,
        textColor: appColors.green,
      ),
      buildPill(
        icon: Icons.arrow_upward_rounded,
        label: 'Keluar',
        value: summary.totalKeluar,
        iconColor: appColors.red,
        iconBgColor: appColors.redBg,
        textColor: appColors.red,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        if (constraints.maxWidth < 600) {
          columns = 1;
        } else {
          columns = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: 64,
            mainAxisSpacing: 8,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return items[index];
          },
        );
      },
    );
  }
}