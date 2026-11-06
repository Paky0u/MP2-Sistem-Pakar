import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF070B14);
  static const Color backgroundEnd = Color(0xFF0D1424);
  static const Color surface = Color(0xFF111A2C);
  static const Color surfaceBorder = Color(0x10FFFFFF);

  static const Color primary = Color(0xFF22D3EE); // Cyan
  static const Color secondary = Color(0xFF3B82F6); // Blue
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFF43F5E); // Rose

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double maxContentWidth = 720.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 14.0;
  static const double lg = 20.0;
  static const double pill = 999.0;
}

class AppFonts {
  static const String mono = 'JetBrainsMono';
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.danger,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
    ),
    fontFamily: 'sans-serif',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.surfaceBorder,
      thickness: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surface,
      contentTextStyle: const TextStyle(color: AppColors.textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.primary),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

bool isReducedMotion(BuildContext context) {
  return MediaQuery.of(context).disableAnimations;
}

Duration appMotion(BuildContext context, [Duration duration = const Duration(milliseconds: 300)]) {
  return isReducedMotion(context) ? Duration.zero : duration;
}
