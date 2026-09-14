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

  final Color border;
  final Color mainBg;

  final Color primary;
  final Color secondary;
  final Color tertiary;

  const AppColors({

    required this.green,
    required this.greenBg,
    required this.red,
    required this.redBg,
    required this.blue,
    required this.blueBg,
    required this.amber,
    required this.amberBg,

    required this.border,
    required this.mainBg,

    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  static const light = AppColors(
    // palette color
    green: Color(0xFF16A34A),
    greenBg: Color(0xFFDCFCE7),

    red: Color(0xFFDC2626),
    redBg: Color(0xFFFEE2E2),

    blue: Color(0xFF2563EB),
    blueBg: Color(0xFFDBEAFE),

    amber: Color(0xFFD97706),
    amberBg: Color(0xFFFEF3C7),

    border: Color(0xFFE2E8F0),
    mainBg: Color(0xFFF8FAFC),

    // unchanged — brand colors
    primary: Color(0xFF0F766E),
    secondary: Color(0xFF18B9AC),
    tertiary: Color(0xFFCCF2EA),
  );

  static const dark = AppColors(
    // palette color
    green: Color(0xFF4ADE80),
    greenBg: Color(0xFF14532D),

    red: Color(0xFFF87171),
    redBg: Color(0xFF450A0A),

    blue: Color(0xFF60A5FA),
    blueBg: Color(0xFF1E3A8A),

    amber: Color(0xFFFBBF24),
    amberBg: Color(0xFF78350F),

    border: Color(0xFF334155),
    mainBg: Color(0xFF0F172A),

    // unchanged — brand colors
    primary: Color(0xFF0F766E),
    secondary: Color(0xFF18B9AC),
    tertiary: Color(0xFFCCF2EA),
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
    Color? border,
    Color? mainBg,
    Color? primary,
    Color? secondary,
    Color? terliary,
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

      border: border ?? this.border,
      mainBg: mainBg ?? this.mainBg,

      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: terliary ?? this.tertiary,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      green: Color.lerp(green, other.green, t)!,
      greenBg: Color.lerp(greenBg, other.greenBg, t)!,

      red: Color.lerp(red, other.red, t)!,
      redBg: Color.lerp(redBg, other.redBg, t)!,

      blue: Color.lerp(blue, other.blue, t)!,
      blueBg: Color.lerp(blueBg, other.blueBg, t)!,

      amber: Color.lerp(amber, other.amber, t)!,
      amberBg: Color.lerp(amberBg, other.amberBg, t)!,

      border: Color.lerp(border, other.border, t)!,
      mainBg: Color.lerp(mainBg, other.mainBg, t)!,

      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
    );
  }
}