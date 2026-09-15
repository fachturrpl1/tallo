import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tallo/features/presentation/transaction_presenter.dart';
import '../../../models/transactions.dart';

class TransactionCard extends StatefulWidget {
  final Transactions transaction;
  final bool overBalance;
  final VoidCallback? onTap;
  final int stok;
  final Function(int)? onQuantityChanged;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.overBalance = false,
    this.onTap,
    this.stok = 10,
    this.onQuantityChanged,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  int jumlah = 1;
  bool isSelected = false; // Status apakah card sedang aktif/diklik

  void _updateJumlah(int inputJumlah) {
    setState(() {
      jumlah = inputJumlah;
    });
    if (widget.onQuantityChanged != null) {
      widget.onQuantityChanged!(inputJumlah);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat.decimalPattern('id_ID');
    final String amountPrefix = widget.transaction.masuk ? '+Rp ' : '-Rp ';

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary.withAlpha(80)
              : colorScheme.outlineVariant.withAlpha(50),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () {
          setState(() {
            isSelected = !isSelected; // Toggle stepper saat diklik
          });
          if (widget.onTap != null) widget.onTap!();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: widget.transaction.categoryBgColor(context),
          child: Icon(
            widget.transaction.icon,
            color: widget.transaction.categoryColor(context),
            size: 20,
          ),
        ),
        title: Text(
          widget.transaction.keterangan,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          '${widget.transaction.tanggalFormatted} • ${widget.transaction.categoriesLabel}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nominal (Kanan Atas)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$amountPrefix${currencyFormat.format(widget.transaction.jumlah * jumlah)}',
                  style: TextStyle(
                    color: widget.transaction.amountColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                // Icon Chevron (Hanya tampil jika stepper belum diklik)
                if (!isSelected) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: colorScheme.onSurfaceVariant.withAlpha(150),
                  ),
                ],
              ],
            ),

            // Stepper Quantity (Hanya tampil saat card diklik)
            if (isSelected) ...[
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(100),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStepperBtn(
                      icon: Icons.remove,
                      onPressed: jumlah > 1 ? () => _updateJumlah(jumlah - 1) : null,
                      colorScheme: colorScheme,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '$jumlah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    _buildStepperBtn(
                      icon: Icons.add,
                      onPressed: jumlah < widget.stok ? () => _updateJumlah(jumlah + 1) : null,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBtn({
    required IconData icon,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
  }) {
    final bool isEnabled = onPressed != null;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 16,
          color: isEnabled
              ? colorScheme.primary
              : colorScheme.onSurface.withAlpha(70),
        ),
      ),
    );
  }
}