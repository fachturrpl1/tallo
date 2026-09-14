import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../models/transactions.dart';

/// Widget overview dashboard untuk menampilkan:
/// 1. Saldo saat ini
/// 2. Total dana masuk (pemasukan)
/// 3. Total dana keluar (pengeluaran)
class DashboardOverview extends StatefulWidget {
  /// Daftar transaksi untuk kalkulasi otomatis
  final List<Transactions>? transactions;

  /// Nilai saldo eksplisit (opsional, jika tidak menggunakan daftar transaksi)
  final int? saldo;

  /// Nilai total dana masuk eksplisit (opsional)
  final int? totalMasuk;

  /// Nilai total dana keluar eksplisit (opsional)
  final int? totalKeluar;

  /// Pengaturan awal untuk visibilitas saldo (default: false / terlihat)
  final bool hideBalanceByDefault;

  /// Margin eksternal widget
  final EdgeInsetsGeometry? margin;

  const DashboardOverview({
    super.key,
    this.transactions,
    this.saldo,
    this.totalMasuk,
    this.totalKeluar,
    this.hideBalanceByDefault = false,
    this.margin,
  });

  /// Factory constructor langsung dari daftar transaksi
  factory DashboardOverview.fromTransactions({
    Key? key,
    required List<Transactions> transactions,
    bool hideBalanceByDefault = false,
    EdgeInsetsGeometry? margin,
  }) {
    return DashboardOverview(
      key: key,
      transactions: transactions,
      hideBalanceByDefault: hideBalanceByDefault,
      margin: margin,
    );
  }

  /// Factory constructor dari nilai nominal manual
  factory DashboardOverview.manual({
    Key? key,
    required int saldo,
    required int totalMasuk,
    required int totalKeluar,
    bool hideBalanceByDefault = false,
    EdgeInsetsGeometry? margin,
  }) {
    return DashboardOverview(
      key: key,
      saldo: saldo,
      totalMasuk: totalMasuk,
      totalKeluar: totalKeluar,
      hideBalanceByDefault: hideBalanceByDefault,
      margin: margin,
    );
  }

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  late bool _isBalanceVisible;

  @override
  void initState() {
    super.initState();
    _isBalanceVisible = !widget.hideBalanceByDefault;
  }

  /// Menghitung total dana masuk
  int get _calculatedMasuk {
    if (widget.totalMasuk != null) return widget.totalMasuk!;
    if (widget.transactions == null) return 0;
    return widget.transactions!
        .where((t) => t.masuk && t.jumlah > 0)
        .fold<int>(0, (sum, t) => sum + t.jumlah);
  }

  /// Menghitung total dana keluar
  int get _calculatedKeluar {
    if (widget.totalKeluar != null) return widget.totalKeluar!;
    if (widget.transactions == null) return 0;
    return widget.transactions!
        .where((t) => !t.masuk && t.jumlah > 0)
        .fold<int>(0, (sum, t) => sum + t.jumlah);
  }

  /// Menghitung saldo saat ini (memanfaatkan hitungSaldo jika ada list transaksi)
  int get _calculatedSaldo {
    if (widget.saldo != null) return widget.saldo!;
    if (widget.transactions != null) {
      return hitungSaldo(widget.transactions!);
    }
    return _calculatedMasuk - _calculatedKeluar;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppColors>() ??
        (isDark ? AppColors.dark : AppColors.light);

    final currencyFormat = NumberFormat.decimalPattern('id_ID');

    final saldoValue = _calculatedSaldo;
    final masukValue = _calculatedMasuk;
    final keluarValue = _calculatedKeluar;

    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: colorScheme.primary, // Menggunakan warna solid primary
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Ornamen dekoratif latar belakang (Solid Soft)
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),

            // Konten Utama
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Saldo & Tombol Toggle Visibilitas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Saldo Saat Ini',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isBalanceVisible = !_isBalanceVisible;
                          });
                        },
                        icon: Icon(
                          _isBalanceVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 20,
                        ),
                        splashRadius: 20,
                        tooltip: _isBalanceVisible
                            ? 'Sembunyikan saldo'
                            : 'Tampilkan saldo',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tampilan Nominal Saldo
                  Text(
                    _isBalanceVisible
                        ? 'Rp ${currencyFormat.format(saldoValue)}'
                        : 'Rp ••••••••',
                    style: textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kotak Ringkasan Dana Masuk & Dana Keluar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? colorScheme.surface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            // Dana Masuk
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: appColors.greenBg,
                                    child: Icon(
                                      Icons.arrow_downward_rounded,
                                      color: appColors.green,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Masuk',
                                          style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _isBalanceVisible
                                                ? '+Rp ${currencyFormat.format(masukValue)}'
                                                : '••••••••',
                                            style: textTheme.labelLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: appColors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Garis Pembatas Vertikal
                            Container(
                              height: 36,
                              width: 1,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              color: colorScheme.outlineVariant,
                            ),

                            // Dana Keluar
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: appColors.redBg,
                                    child: Icon(
                                      Icons.arrow_upward_rounded,
                                      color: appColors.red,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Keluar',
                                          style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _isBalanceVisible
                                                ? '-Rp ${currencyFormat.format(keluarValue)}'
                                                : '••••••••',
                                            style: textTheme.labelLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: appColors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
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

/// Alias agar mudah diimport dengan nama OverviewCard
typedef OverviewCard = DashboardOverview;