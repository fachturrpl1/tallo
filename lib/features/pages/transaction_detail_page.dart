import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transactions.dart';
import '../presentation/transaction_presenter.dart';

class TransactionDetailPage extends StatefulWidget {
  final Transactions transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  int _jumlah = 1;
  final int _stok = 10;

  Widget _infoRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat.decimalPattern('id_ID');
    final String amountPrefix = widget.transaction.masuk ? '+Rp ' : '-Rp ';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Transaksi
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: widget.transaction.categoryBgColor(context),
                          child: Icon(
                            widget.transaction.icon,
                            color: widget.transaction.categoryColor(context),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.transaction.keterangan,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.transaction.tanggalFormatted,
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    
                    // Stepper Nominal
                    Text(
                      'Jumlah',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withAlpha(120),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$amountPrefix${currencyFormat.format(widget.transaction.jumlah * _jumlah)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.transaction.amountColor(context),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: _jumlah > 1
                                    ? () => setState(() => _jumlah--)
                                    : null,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest.withAlpha(100),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: _jumlah > 1
                                        ? colorScheme.primary
                                        : colorScheme.onSurface.withAlpha(60),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  '$_jumlah',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: _jumlah < _stok
                                    ? () => setState(() => _jumlah++)
                                    : null,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest.withAlpha(100),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: _jumlah < _stok
                                        ? colorScheme.primary
                                        : colorScheme.onSurface.withAlpha(60),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    _infoRow(context, 'Label', widget.transaction.keterangan),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    _infoRow(context, 'Kategori', widget.transaction.categoriesLabel),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                  ],
                ),
              ),
            ),

            // Tombol Edit & Hapus (Tanpa Aksi, Tanpa Gelombang, & Tanpa Sorotan Warna)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
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
                        
                        enableFeedback: false,
                      ).copyWith(
                        splashFactory: NoSplash.splashFactory,
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
                        
                        enableFeedback: false,
                      ).copyWith(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Hapus'),
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
}