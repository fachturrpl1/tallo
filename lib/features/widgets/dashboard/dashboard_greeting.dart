import 'package:flutter/material.dart';

class DashboardGreeting extends StatelessWidget {
  final String userName;
  final bool isDarkMode;
  final VoidCallback? onThemeToggle;

  const DashboardGreeting({
    super.key,
    required this.userName,
    required this.isDarkMode,
    this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $userName 👋',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Semangat terus untuk usahamu!',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onThemeToggle,
          icon: Icon(
            isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}