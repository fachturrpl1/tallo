// app_colors.dart — versi final, tanpa duplikasi
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color green;
  final Color greenBg;
  final Color red;
  final Color redBg;
  final Color blue;
  final Color blueBg;
  final Color amber;
  final Color amberBg;

  const AppColors({
    required this.green,
    required this.greenBg,
    required this.red,
    required this.redBg,
    required this.blue,
    required this.blueBg,
    required this.amber,
    required this.amberBg,
  });

  static const light = AppColors(
    green: Color(0xFF16A34A),
    greenBg: Color(0xFFDCFCE7),
    red: Color(0xFFDC2626),
    redBg: Color(0xFFFEE2E2),
    blue: Color(0xFF2563EB),
    blueBg: Color(0xFFDBEAFE),
    amber: Color(0xFFD97706),
    amberBg: Color(0xFFFEF3C7),
  );

  static const dark = AppColors(
    green: Color(0xFF4ADE80),
    greenBg: Color(0xFF14532D),
    red: Color(0xFFF87171),
    redBg: Color(0xFF450A0A),
    blue: Color(0xFF60A5FA),
    blueBg: Color(0xFF1E3A8A),
    amber: Color(0xFFFBBF24),
    amberBg: Color(0xFF78350F),
  );

  @override
  AppColors copyWith({
    Color? green,
    Color? greenBg,
    Color? red,
    Color? redBg,
    Color? blue,
    Color? blueBg,
    Color? amber,
    Color? amberBg,
  }) {
    return AppColors(
      green: green ?? this.green,
      greenBg: greenBg ?? this.greenBg,
      red: red ?? this.red,
      redBg: redBg ?? this.redBg,
      blue: blue ?? this.blue,
      blueBg: blueBg ?? this.blueBg,
      amber: amber ?? this.amber,
      amberBg: amberBg ?? this.amberBg,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      green: Color.lerp(green, other.green, t)!,
      greenBg: Color.lerp(greenBg, other.greenBg, t)!,
      red: Color.lerp(red, other.red, t)!,
      redBg: Color.lerp(redBg, other.redBg, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      blueBg: Color.lerp(blueBg, other.blueBg, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      amberBg: Color.lerp(amberBg, other.amberBg, t)!,
    );
  }
}