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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor:
                highlighted ? colorScheme.primary : colorScheme.surfaceContainerLow,
            child: Icon(
              icon,
              color: highlighted ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}