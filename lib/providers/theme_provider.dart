// lib/providers/theme_provider.dart - Modern NASA Tema
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

// NASA Renk Paleti
class NasaColors {
  static const Color primaryBlue = Color(0xFF0B3D91); // NASA Mavi
  static const Color secondaryBlue = Color(0xFF1E3A8A);
  static const Color accentOrange = Color(0xFFFF6B35); // NASA Turuncu
  static const Color spaceBlack = Color(0xFF0A0A0A);
  static const Color cosmicPurple = Color(0xFF6B46C1);
  static const Color stellarWhite = Color(0xFFF8FAFC);
  static const Color nebulaGrey = Color(0xFF64748B);
  static const Color darkSpace = Color(0xFF1A1A2E);
  static const Color deepSpace = Color(0xFF16213E);
}

// Tema modu provider'ı
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.dark; // Varsayılan karanlık tema (uzay teması)
  }

  void toggleTheme() {
    switch (state) {
      case ThemeMode.light:
        state = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        state = ThemeMode.light;
        break;
      case ThemeMode.system:
        state = ThemeMode.dark;
        break;
    }
  }

  void setTheme(ThemeMode themeMode) {
    state = themeMode;
  }
}

// Modern NASA Tema
@riverpod
ThemeData theme(ThemeRef ref) {
  final themeMode = ref.watch(themeModeNotifierProvider);
  final isDark = themeMode == ThemeMode.dark;
  
  return ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    
    // Renk Şeması
    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: NasaColors.primaryBlue,
      onPrimary: Colors.white,
      secondary: NasaColors.accentOrange,
      onSecondary: Colors.white,
      tertiary: NasaColors.cosmicPurple,
      onTertiary: Colors.white,
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      background: isDark ? NasaColors.darkSpace : NasaColors.stellarWhite,
      onBackground: isDark ? Colors.white : NasaColors.spaceBlack,
      surface: isDark ? NasaColors.deepSpace : Colors.white,
      onSurface: isDark ? Colors.white : NasaColors.spaceBlack,
      surfaceVariant: isDark ? NasaColors.nebulaGrey.withOpacity(0.1) : Colors.grey[100]!,
      onSurfaceVariant: isDark ? Colors.grey[300]! : Colors.grey[700]!,
      outline: isDark ? Colors.grey[600]! : Colors.grey[300]!,
      outlineVariant: isDark ? Colors.grey[800]! : Colors.grey[200]!,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? Colors.white : NasaColors.spaceBlack,
      onInverseSurface: isDark ? NasaColors.spaceBlack : Colors.white,
      inversePrimary: NasaColors.accentOrange,
      surfaceTint: NasaColors.primaryBlue,
    ),
    
    // AppBar Teması
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? NasaColors.darkSpace : NasaColors.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    
    // Card Teması
    cardTheme: CardThemeData(
      elevation: isDark ? 8 : 4,
      shadowColor: isDark ? Colors.black : Colors.grey[300]!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark ? NasaColors.deepSpace : Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    
    // Elevated Button Teması
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: NasaColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: NasaColors.primaryBlue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Text Button Teması
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: NasaColors.accentOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Icon Teması
    iconTheme: IconThemeData(
      color: isDark ? Colors.white : NasaColors.primaryBlue,
      size: 24,
    ),
    
    // Text Teması
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : NasaColors.spaceBlack,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : NasaColors.spaceBlack,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : NasaColors.spaceBlack,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : NasaColors.spaceBlack,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : NasaColors.spaceBlack,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : NasaColors.spaceBlack,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : NasaColors.spaceBlack,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.grey[300]! : Colors.grey[700]!,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.grey[400]! : Colors.grey[600]!,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: isDark ? Colors.grey[300]! : Colors.grey[700]!,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.grey[300]! : Colors.grey[700]!,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: isDark ? Colors.grey[400]! : Colors.grey[600]!,
      ),
    ),
    
    // Bottom Navigation Bar Teması
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: isDark ? NasaColors.darkSpace : NasaColors.primaryBlue,
      selectedItemColor: NasaColors.accentOrange,
      unselectedItemColor: isDark ? Colors.grey[400]! : Colors.white70,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Floating Action Button Teması
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: NasaColors.accentOrange,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Input Decoration Teması
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? NasaColors.deepSpace : Colors.grey[50]!,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: NasaColors.primaryBlue,
          width: 2,
        ),
      ),
      labelStyle: TextStyle(
        color: isDark ? Colors.grey[300]! : Colors.grey[700]!,
      ),
    ),
    
    // Divider Teması
    dividerTheme: DividerThemeData(
      color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
      thickness: 1,
      space: 1,
    ),
    
    // Chip Teması
    chipTheme: ChipThemeData(
      backgroundColor: isDark ? NasaColors.deepSpace : Colors.grey[100]!,
      selectedColor: NasaColors.primaryBlue,
      labelStyle: TextStyle(
        color: isDark ? Colors.white : NasaColors.spaceBlack,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
} 