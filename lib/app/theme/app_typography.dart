import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography configuration using Google Fonts (Inter & Outfit).
abstract class AppTypography {
  static TextStyle displayLarge(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        letterSpacing: -0.5,
      );

  static TextStyle titleLarge(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle bodyMedium(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      );

  static TextStyle labelBold(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );
}
