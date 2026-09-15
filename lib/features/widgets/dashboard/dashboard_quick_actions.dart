import 'package:flutter/material.dart';

class DashboardQuickActions extends StatelessWidget {
  final VoidCallback? onTambahTap;
  final VoidCallback? onKategoriTap;
  final VoidCallback? onLaporanTap;
  final VoidCallback? onLainnyaTap;

  const DashboardQuickActions({
    super.key,
    this.onTambahTap,
    this.onKategoriTap,
    this.onLaporanTap,
    this.onLainnyaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // sebelumnya: spaceBetween
      children: [
        _QuickActionButton(
          icon: Icons.add,
          label: 'Tambah',
          highlighted: true,
          onTap: onTambahTap,
        ),
        _QuickActionButton(
          icon: Icons.grid_view_rounded,
          label: 'Kategori',
          onTap: onKategoriTap,
        ),
        _QuickActionButton(
          icon: Icons.insert_chart_outlined_rounded,
          label: 'Laporan',
          onTap: onLaporanTap,
        ),
        _QuickActionButton(
          icon: Icons.more_horiz_rounded,
          label: 'Lainnya',
          onTap: onLainnyaTap,
        ),
      ],
    );
  }
}
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  final VoidCallback? onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    this.highlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Material( // tambahan — supaya InkWell punya ripple layer sendiri, terbatas di lingkaran
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias, // memotong ripple supaya tetap dalam lingkaran
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(), // ripple mengikuti bentuk lingkaran, bukan kotak
              child: CircleAvatar(
                radius: 24,
                backgroundColor:
                    highlighted ? colorScheme.primary : colorScheme.surfaceContainerLow,
                child: Icon(
                  icon,
                  color: highlighted ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector( // tambahan — label ikut bisa di-tap juga, tapi tanpa ripple
            onTap: onTap,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}