import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import 'transactions_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _delay() async {
    await Future.delayed(
      const Duration(seconds: 7),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return FutureBuilder<void>(
      future: _delay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const TransactionPage(
            TransactionsList: []
            );
        }

        return Scaffold(
          backgroundColor: colors.primary,
          body: SafeArea(
            child: Align(
              alignment: const Alignment(0, -0.2), // -0.2 menggeser sedikit ke atas dari tengah
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'static/logoname.png',
                    width: 220,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Know your money flow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}