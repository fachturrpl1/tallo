import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../models/transactions.dart';
import 'transactions_page.dart';

class SplashScreen extends StatefulWidget {
  final List<Transactions> transactionsList;

  const SplashScreen({super.key, required this.transactionsList});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TransactionsPage(
          transactionsList: widget.transactionsList, // <-- diteruskan, bukan []
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors= Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Align(
          alignment: const Alignment(0, -0.2),
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
  }
}