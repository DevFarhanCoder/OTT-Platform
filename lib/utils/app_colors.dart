import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1E3A8A); // Dark Blue
  static const Color secondaryColor = Color(0xFFDC2626); // Red
  static const Color accentColor = Color(0xFFF59E0B); // Orange/Gold
  static const Color backgroundColor = Color(0xFF0F172A); // Dark Background
  static const Color cardColor = Color(0xFF1E293B); // Dark Card Background
  static const Color surfaceColor = Color(0xFF334155); // Light Surface
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFF94A3B8); // Light Gray
  static const Color textTertiary = Color(0xFF64748B); // Medium Gray
  static const Color dividerColor = Color(0xFF475569); // Divider
  static const Color successColor = Color(0xFF059669); // Green
  static const Color warningColor = Color(0xFFD97706); // Orange
  static const Color errorColor = Color(0xFFDC2626); // Red
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [cardColor, Color(0xFF2D3748)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const RadialGradient backgroundGradient = RadialGradient(
    colors: [Color(0xFF1E293B), backgroundColor],
    center: Alignment.topCenter,
    radius: 2.0,
  );
}