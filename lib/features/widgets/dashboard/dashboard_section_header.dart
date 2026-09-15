// File: widgets/dashboard/dashboard_section_header.dart
import 'package:flutter/material.dart';

class DashboardSectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  const DashboardSectionHeader({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                actionLabel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}