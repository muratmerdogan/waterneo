import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_system.dart';

/// Uygulama teması ve renk paleti - Modern Pastel Design
class AppTheme {
  // Primary renk (soft blues & turquoise)
  static const Color primaryColor = DesignSystem.primaryTurquoise;
  static const Color primaryLight = DesignSystem.pastelTurquoise;
  static const Color primaryDark = DesignSystem.primaryCyan;

  // Açık tema renkleri
  static const Color backgroundColorLight = DesignSystem.lightBackground;
  static const Color cardColorLight = DesignSystem.lightCard;
  static const Color textColorLight = DesignSystem.lightTextPrimary;
  static const Color textSecondaryLight = DesignSystem.lightTextSecondary;

  // Koyu tema renkleri
  static const Color backgroundColorDark = DesignSystem.darkBackground;
  static const Color cardColorDark = DesignSystem.darkCard;
  static const Color textColorDark = DesignSystem.darkTextPrimary;
  static const Color textSecondaryDark = DesignSystem.darkTextSecondary;

  // Durum renkleri
  static const Color successColor = DesignSystem.accentSuccess;
  static const Color warningColor = DesignSystem.accentWarning;
  static const Color errorColor = DesignSystem.accentError;

  /// Açık tema
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColorLight,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: primaryLight,
        surface: cardColorLight,
        error: errorColor,
      ),
      cardTheme: CardThemeData(
        color: cardColorLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
        ),
        shadowColor: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: textColorLight),
        titleTextStyle: TextStyle(
          color: textColorLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textColorLight),
        displayMedium: TextStyle(color: textColorLight),
        displaySmall: TextStyle(color: textColorLight),
        headlineLarge: TextStyle(color: textColorLight),
        headlineMedium: TextStyle(color: textColorLight),
        headlineSmall: TextStyle(color: textColorLight),
        titleLarge: TextStyle(color: textColorLight),
        titleMedium: TextStyle(color: textColorLight),
        titleSmall: TextStyle(color: textColorLight),
        bodyLarge: TextStyle(color: textColorLight),
        bodyMedium: TextStyle(color: textColorLight),
        bodySmall: TextStyle(color: textSecondaryLight),
        labelLarge: TextStyle(color: textColorLight),
        labelMedium: TextStyle(color: textColorLight),
        labelSmall: TextStyle(color: textSecondaryLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingXL,
            vertical: DesignSystem.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingXL,
            vertical: DesignSystem.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingXL,
            vertical: DesignSystem.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          ),
          side: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColorLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingM,
          vertical: DesignSystem.spacingM,
        ),
      ),
    );
  }

  /// Koyu tema
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColorDark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryLight,
        surface: cardColorDark,
        error: errorColor,
      ),
      cardTheme: CardThemeData(
        color: cardColorDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
        ),
        shadowColor: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: textColorDark),
        titleTextStyle: TextStyle(
          color: textColorDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textColorDark),
        displayMedium: TextStyle(color: textColorDark),
        displaySmall: TextStyle(color: textColorDark),
        headlineLarge: TextStyle(color: textColorDark),
        headlineMedium: TextStyle(color: textColorDark),
        headlineSmall: TextStyle(color: textColorDark),
        titleLarge: TextStyle(color: textColorDark),
        titleMedium: TextStyle(color: textColorDark),
        titleSmall: TextStyle(color: textColorDark),
        bodyLarge: TextStyle(color: textColorDark),
        bodyMedium: TextStyle(color: textColorDark),
        bodySmall: TextStyle(color: textSecondaryDark),
        labelLarge: TextStyle(color: textColorDark),
        labelMedium: TextStyle(color: textColorDark),
        labelSmall: TextStyle(color: textSecondaryDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingXL,
            vertical: DesignSystem.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingXL,
            vertical: DesignSystem.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingXL,
            vertical: DesignSystem.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          ),
          side: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColorDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingM,
          vertical: DesignSystem.spacingM,
        ),
      ),
    );
  }
}

