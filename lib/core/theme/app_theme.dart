import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF2D6A4F);
  static const Color primaryLight = Color(0xFF52B788);
  static const Color primaryDark = Color(0xFF1B4332);
  static const Color accent = Color(0xFFD4A017);
  static const Color background = Color(0xFFF8F5F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF4A4A6A);
  static const Color textLight = Color(0xFF9A9AB0);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE8E4DF);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: accent,
          surface: surface,
          background: background,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          iconTheme: IconThemeData(color: textDark),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
            color: textDark,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
            color: textDark,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
            color: textMedium,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
            color: textLight,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
            color: surface,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: divider, width: 1),
          ),
        ),
      );
}
