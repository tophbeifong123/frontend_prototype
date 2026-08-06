import 'package:flutter/material.dart';

/// App color palette definition following Nintendo Switch UI inspired design system.
abstract class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF0C60A1); // Nintendo / Primary Blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF074375);
  static const Color textDark = Color(0xFF0A1C2C); // Dark Navy Text
  static const Color backgroundLight = Color(0xFFEAF1F7); // Light Grey-Blue

  // Pastel Type Backgrounds
  static const Color pastelGrass = Color(0xFFE0F2E9); // Mint Pastel
  static const Color pastelFire = Color(0xFFFAEBE1); // Peach Pastel
  static const Color pastelWater = Color(0xFFE0EFFB); // Sky Pastel
  static const Color pastelElectric = Color(0xFFFFF6D6); // Yellow Pastel
  static const Color pastelPsychic = Color(0xFFFCE4EC); // Pink Pastel
  static const Color pastelDefault = Color(0xFFF0F3F6); // Grey-Blue Pastel

  // Type Icon/Accent Colors
  static const Color typeGrass = Color(0xFF2E7D32);
  static const Color typeFire = Color(0xFFD84315);
  static const Color typeWater = Color(0xFF1565C0);
  static const Color typeElectric = Color(0xFFF57F17);
  static const Color typePsychic = Color(0xFFC2185B);
  static const Color typePoison = Color(0xFF6A1B9A);
  static const Color typeFlying = Color(0xFF0288D1);

  // Secondary & Neutral
  static const Color secondary = Color(0xFF10B981);
  static const Color accent = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);

  // Dark Mode Focus
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);
  static const Color borderDark = Color(0xFF475569);

  // Light Mode Focus
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF0F3F6);
  static const Color borderLight = Color(0xFFD3E0EA);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textPrimaryLight = Color(0xFF0A1C2C);
  static const Color textSecondaryLight = Color(0xFF5A6E7F);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0C60A1), Color(0xFF1E88E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
