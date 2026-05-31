// Milaud Premium Design System
// Milaor-inspired color palette and Material 3 design system

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ===== MILAOR COLOR PALETTE =====
  static const Color milaorBlue =
      Color(0xFF0056A3); // Primary: Milaor municipal blue
  static const Color philippineGold =
      Color(0xFFFDB913); // Secondary: Philippine gold
  static const Color philippineRed =
      Color(0xFFCE1126); // Accent: Philippine red
  static const Color philippineGreen =
      Color(0xFF0C5A43); // Success: Philippine green
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutralGray50 = Color(0xFFF8F9FA);
  static const Color neutralGray100 = Color(0xFFE9ECEF);
  static const Color neutralGray200 = Color(0xFFDEE2E6);
  static const Color neutralGray500 = Color(0xFF6C757D);
  static const Color neutralGray800 = Color(0xFF343A40);
  static const Color neutralBlack = Color(0xFF212529);

  // Semantic colors
  static const Color success = philippineGreen;
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [milaorBlue, Color(0xFF0077CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== TYPOGRAPHY =====
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.12,
    color: neutralBlack,
  );

  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    height: 1.16,
    color: neutralBlack,
  );

  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.22,
    color: neutralBlack,
  );

  static TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: neutralBlack,
  );

  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
    color: neutralBlack,
  );

  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    color: neutralBlack,
  );

  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
    color: neutralBlack,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: neutralBlack,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    color: neutralGray800,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: neutralGray800,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: neutralGray800,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    color: neutralGray500,
  );

  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    color: milaorBlue,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    color: milaorBlue,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: neutralGray500,
  );

  // ===== SPACING =====
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  static const double spacingXxxl = 64.0;

  // ===== BORDER RADIUS =====
  static const double borderRadiusXs = 4.0;
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 24.0;
  static const double borderRadiusCircle = 100.0;

  // ===== SHADOWS =====
  static const List<BoxShadow> shadowXs = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x29000000), blurRadius: 16, offset: Offset(0, 8)),
  ];
  static const List<BoxShadow> shadowXl = [
    BoxShadow(color: Color(0x3D000000), blurRadius: 24, offset: Offset(0, 12)),
  ];

  // ===== ANIMATIONS =====
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ===== LIGHT THEME =====
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: milaorBlue,
        secondary: philippineGold,
        surface: neutralWhite,
        background: neutralGray50,
        error: error,
      ),
      scaffoldBackgroundColor: neutralGray50,
      appBarTheme: AppBarTheme(
        backgroundColor: neutralWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: titleLarge.copyWith(color: neutralBlack),
        iconTheme: const IconThemeData(color: milaorBlue),
      ),
      cardTheme: CardThemeData(
        color: neutralWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
        ),
        margin: EdgeInsets.zero,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: milaorBlue,
          foregroundColor: neutralWhite,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          textStyle: labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMd),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: milaorBlue,
          side: const BorderSide(color: milaorBlue),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          textStyle: labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMd),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: milaorBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          textStyle: labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: neutralWhite,
        contentPadding: const EdgeInsets.all(spacingMd),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
          borderSide: const BorderSide(color: neutralGray100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
          borderSide: const BorderSide(color: neutralGray100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
          borderSide: const BorderSide(color: milaorBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
          borderSide: const BorderSide(color: error),
        ),
        labelStyle: bodyMedium.copyWith(color: neutralGray500),
        hintStyle: bodyMedium.copyWith(color: neutralGray500),
        errorStyle: bodySmall.copyWith(color: error),
      ),
      dividerTheme: const DividerThemeData(
        color: neutralGray200,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: neutralGray100,
        selectedColor: milaorBlue,
        labelStyle: labelSmall,
        secondaryLabelStyle: labelSmall.copyWith(color: neutralWhite),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingSm,
          vertical: spacingXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusCircle),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: neutralWhite,
        selectedItemColor: milaorBlue,
        unselectedItemColor: neutralGray500,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: milaorBlue,
        foregroundColor: neutralWhite,
        elevation: 4,
      ),
    );
  }

  // ===== DARK THEME =====
  static ThemeData darkTheme() {
    // Dark mode color constants
    const Color darkSurface = Color(0xFF1E1E1E);
    const Color darkBackground = Color(0xFF121212);
    const Color darkPrimary = Color(0xFF66B5FF);
    const Color darkCard = Color(0xFF2C2C2C);
    const Color darkBorder = Color(0xFF444444);
    const Color darkSubtext = Color(0xFF9E9E9E);
    const Color darkDivider = Color(0xFF333333);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: Color(0xFFFFD166),
        surface: darkSurface,
        background: darkBackground,
        error: Color(0xFFCF6679),
      ),
      scaffoldBackgroundColor: darkBackground,

      // ← FIXED: was only this section before
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: titleLarge.copyWith(color: neutralWhite),
        iconTheme: const IconThemeData(color: darkPrimary),
      ),

      // ← ADDED: cards were showing light color in dark mode
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
        ),
        margin: EdgeInsets.zero,
      ),

      // ← ADDED: buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkBackground,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          textStyle: labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMd),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          side: const BorderSide(color: darkPrimary),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMd),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
        ),
      ),

      // ← ADDED: input fields were showing white background in dark mode
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        contentPadding: const EdgeInsets.all(spacingMd),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMd),
          borderSide: const BorderSide(color: Color(0xFFCF6679)),
        ),
        labelStyle: bodyMedium.copyWith(color: darkSubtext),
        hintStyle: bodyMedium.copyWith(color: darkSubtext),
        errorStyle: bodySmall.copyWith(color: Color(0xFFCF6679)),
      ),

      // ← ADDED
      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCard,
        selectedColor: darkPrimary,
        labelStyle: labelSmall.copyWith(color: neutralWhite),
        secondaryLabelStyle: labelSmall.copyWith(color: darkBackground),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingSm,
          vertical: spacingXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusCircle),
        ),
      ),

      // ← ADDED: nav bar was staying white in dark mode
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkPrimary,
        unselectedItemColor: darkSubtext,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: darkBackground,
        elevation: 4,
      ),
    );
  }

  // ===== TEXT STYLE HELPERS =====
  static TextStyle responsiveText({
    required BuildContext context,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // ===== CUSTOM WIDGET STYLES =====
  static BoxDecoration cardDecoration({bool elevated = true}) {
    return BoxDecoration(
      color: neutralWhite,
      borderRadius: BorderRadius.circular(borderRadiusMd),
      boxShadow: elevated ? shadowSm : null,
      border: elevated ? null : Border.all(color: neutralGray100),
    );
  }

  static BoxDecoration primaryCardDecoration() {
    return BoxDecoration(
      gradient: primaryGradient,
      borderRadius: BorderRadius.circular(borderRadiusLg),
      boxShadow: shadowMd,
    );
  }

  static BoxDecoration outlineDecoration({Color color = milaorBlue}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadiusMd),
      border: Border.all(color: color),
    );
  }

  // ===== PADDING HELPERS =====
  static EdgeInsets paddingAll(double value) => EdgeInsets.all(value);
  static EdgeInsets paddingHorizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);
  static EdgeInsets paddingVertical(double value) =>
      EdgeInsets.symmetric(vertical: value);
  static EdgeInsets paddingSym({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  // ===== MARGIN HELPERS =====
  static EdgeInsets marginAll(double value) => EdgeInsets.all(value);
  static EdgeInsets marginHorizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);
  static EdgeInsets marginVertical(double value) =>
      EdgeInsets.symmetric(vertical: value);

  // ===== SIZING HELPERS =====
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static bool isMobile(BuildContext context) => getScreenWidth(context) < 600;
  static bool isTablet(BuildContext context) =>
      getScreenWidth(context) >= 600 && getScreenWidth(context) < 1200;
  static bool isDesktop(BuildContext context) =>
      getScreenWidth(context) >= 1200;
}