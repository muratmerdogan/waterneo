import 'package:flutter/material.dart';

/// Modern Design System - Pastel colors, clean UI
class DesignSystem {
  // Pastel Color Palette
  static const Color pastelBlue = Color(0xFFB3E5FC); // Soft blue
  static const Color pastelTurquoise = Color(0xFFB2DFDB); // Turquoise
  static const Color pastelCyan = Color(0xFFB2EBF2); // Cyan
  static const Color pastelGreen = Color(0xFFC8E6C9); // Green
  static const Color pastelPurple = Color(0xFFE1BEE7); // Purple
  
  // Primary Colors (Soft blues & turquoise)
  static const Color primaryBlue = Color(0xFF64B5F6);
  static const Color primaryTurquoise = Color(0xFF4DB6AC);
  static const Color primaryCyan = Color(0xFF26C6DA);
  
  // Light Mode Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightDivider = Color(0xFFE0E0E0);
  
  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF3A3A3A);
  
  // Accent Colors
  static const Color accentSuccess = Color(0xFF66BB6A);
  static const Color accentWarning = Color(0xFFFFB74D);
  static const Color accentError = Color(0xFFEF5350);
  static const Color accentInfo = Color(0xFF42A5F5);
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusRound = 999.0;
  
  // Spacing System
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Typography
  static const String fontFamily = 'SF Pro Display'; // iOS native feel
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Curves
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  
  // Shadows
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get darkShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 30,
      offset: const Offset(0, 8),
    ),
  ];
}

/// Typography Styles
class AppTypography {
  // Display
  static TextStyle displayLarge(BuildContext context) => Theme.of(context).textTheme.displayLarge!.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.25,
  );
  
  static TextStyle displayMedium(BuildContext context) => Theme.of(context).textTheme.displayMedium!.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  
  static TextStyle displaySmall(BuildContext context) => Theme.of(context).textTheme.displaySmall!.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  
  // Headline
  static TextStyle headlineLarge(BuildContext context) => Theme.of(context).textTheme.headlineLarge!.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  
  static TextStyle headlineMedium(BuildContext context) => Theme.of(context).textTheme.headlineMedium!.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  
  static TextStyle headlineSmall(BuildContext context) => Theme.of(context).textTheme.headlineSmall!.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  
  // Title
  static TextStyle titleLarge(BuildContext context) => Theme.of(context).textTheme.titleLarge!.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  
  static TextStyle titleMedium(BuildContext context) => Theme.of(context).textTheme.titleMedium!.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );
  
  static TextStyle titleSmall(BuildContext context) => Theme.of(context).textTheme.titleSmall!.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );
  
  // Body
  static TextStyle bodyLarge(BuildContext context) => Theme.of(context).textTheme.bodyLarge!.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  
  static TextStyle bodyMedium(BuildContext context) => Theme.of(context).textTheme.bodyMedium!.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
  
  static TextStyle bodySmall(BuildContext context) => Theme.of(context).textTheme.bodySmall!.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );
  
  // Label
  static TextStyle labelLarge(BuildContext context) => Theme.of(context).textTheme.labelLarge!.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );
  
  static TextStyle labelMedium(BuildContext context) => Theme.of(context).textTheme.labelMedium!.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  
  static TextStyle labelSmall(BuildContext context) => Theme.of(context).textTheme.labelSmall!.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}

