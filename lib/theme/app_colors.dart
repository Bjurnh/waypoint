import 'package:flutter/material.dart';

/// App color constants matching the React Christian Spiritual Growth App
/// Colors are converted from CSS custom properties in globals.css
class AppColors {
  AppColors._();

  // ============================================
  // Light Theme Colors
  // ============================================
  
  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF1A1A2E); // oklch(0.145 0 0) converted
  
  // Cards
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF1A1A2E);
  
  // Popover
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF1A1A2E);
  
  // Primary
  static const Color primary = Color(0xFF030213);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  
  // Secondary
  static const Color secondary = Color(0xFFF5F5F7); // oklch(0.95 0.0058 264.53)
  static const Color secondaryForeground = Color(0xFF030213);
  
  // Muted
  static const Color muted = Color(0xFFECECF0);
  static const Color mutedForeground = Color(0xFF717182);
  
  // Accent
  static const Color accent = Color(0xFFE9EBEF);
  static const Color accentForeground = Color(0xFF030213);
  
  // Destructive
  static const Color destructive = Color(0xFFD4183D);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  
  // Border & Input
  static const Color border = Color(0x1A000000); // rgba(0, 0, 0, 0.1)
  static const Color input = Colors.transparent;
  static const Color inputBackground = Color(0xFFF3F3F5);
  static const Color switchBackground = Color(0xFFCBCED4);
  
  // Ring
  static const Color ring = Color(0xFFB4B4B4); // oklch(0.708 0 0)
  
  // Chart Colors
  static const Color chart1 = Color(0xFF8B5CF6); // oklch(0.646 0.222 41.116)
  static const Color chart2 = Color(0xFF10B981); // oklch(0.6 0.118 184.704)
  static const Color chart3 = Color(0xFF6B7280); // oklch(0.398 0.07 227.392)
  static const Color chart4 = Color(0xFFF59E0B); // oklch(0.828 0.189 84.429)
  static const Color chart5 = Color(0xFFEC4899); // oklch(0.769 0.188 70.08)
  
  // Sidebar
  static const Color sidebar = Color(0xFFFAFAFA); // oklch(0.985 0 0)
  static const Color sidebarForeground = Color(0xFF1A1A2E);
  static const Color sidebarPrimary = Color(0xFF030213);
  static const Color sidebarPrimaryForeground = Color(0xFFFAFAFA);
  static const Color sidebarAccent = Color(0xFFF7F7F7); // oklch(0.97 0 0)
  static const Color sidebarAccentForeground = Color(0xFF1A1A2E);
  static const Color sidebarBorder = Color(0xFFECECEC); // oklch(0.922 0 0)
  static const Color sidebarRing = Color(0xFFB4B4B4);
  
  // ============================================
  // Gradient Colors for Screen Backgrounds
  // ============================================
  
  // Home Screen - Blue to Purple
  static const Color homeGradientStart = Color(0xFFEFF6FF); // blue-50
  static const Color homeGradientMid = Color(0xFFF3E8FF); // purple-50/30
  static const Color homeGradientEnd = Color(0xFFFFFFFF); // white
  
  // Prayer Log Screen - Pink to Purple
  static const Color prayerGradientStart = Color(0xFFFDF2F8); // pink-50
  static const Color prayerGradientMid = Color(0xFFF3E8FF); // purple-50/30
  static const Color prayerGradientEnd = Color(0xFFFFFFFF); // white
  
  // Progress Dashboard - Indigo to Purple
  static const Color progressGradientStart = Color(0xFFEEF2FF); // indigo-50
  static const Color progressGradientMid = Color(0xFFF3E8FF); // purple-50/30
  static const Color progressGradientEnd = Color(0xFFFFFFFF); // white
  
  // Habit Tracking - Green to Teal
  static const Color habitGradientStart = Color(0xFFECFDF5); // emerald-50
  static const Color habitGradientMid = Color(0xFFECFEFF); // cyan-50/30
  static const Color habitGradientEnd = Color(0xFFFFFFFF); // white
  
  // Profile Screen - Amber to Orange
  static const Color profileGradientStart = Color(0xFFFEF3C7); // amber-50
  static const Color profileGradientMid = Color(0xFFFEF3C7); // amber-50/30
  static const Color profileGradientEnd = Color(0xFFFFFFFF); // white
  
  // Plan Generation - Violet to Purple
  static const Color planGradientStart = Color(0xFFFAF5FF); // violet-50
  static const Color planGradientMid = Color(0xFFF3E8FF); // purple-50/30
  static const Color planGradientEnd = Color(0xFFFFFFFF); // white
  
  // ============================================
  // Button & Card Gradient Colors
  // ============================================
  
  // Blue gradient
  static const Color blueGradientStart = Color(0xFF60A5FA); // blue-400
  static const Color blueGradientEnd = Color(0xFF8B5CF6); // purple-400
  
  // Purple gradient
  static const Color purpleGradientStart = Color(0xFFA78BFA); // purple-400
  static const Color purpleGradientEnd = Color(0xFF8B5CF6); // purple-500
  
  // Pink gradient
  static const Color pinkGradientStart = Color(0xFFF472B6); // pink-400
  static const Color pinkGradientEnd = Color(0xFFEC4899); // pink-500
  
  // Orange gradient (for streaks)
  static const Color orangeGradientStart = Color(0xFFFB923C); // orange-400
  static const Color orangeGradientEnd = Color(0xFFEF4444); // red-500
  
  // Indigo gradient
  static const Color indigoGradientStart = Color(0xFF818CF8); // indigo-400
  static const Color indigoGradientEnd = Color(0xFFA78BFA); // purple-400
  
  // Green gradient
  static const Color greenGradientStart = Color(0xFF34D399); // emerald-400
  static const Color greenGradientEnd = Color(0xFF10B981); // emerald-500
  
  // Teal gradient
  static const Color tealGradientStart = Color(0xFF2DD4BF); // teal-400
  static const Color tealGradientEnd = Color(0xFF14B8A6); // teal-500
  
  // ============================================
  // Decorative Background Blur Colors
  // ============================================
  
  // Blue decorative
  static const Color blueDecorative = Color(0xFFDBEAFE); // blue-200/20
  static const Color purpleDecorative = Color(0xFFEDE9FE); // purple-200/20
  static const Color pinkDecorative = Color(0xFFFCE7F3); // pink-200/20
  static const Color indigoDecorative = Color(0xFFE0E7FF); // indigo-200/20
  
  // ============================================
  // Text Colors
  // ============================================
  
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF717182);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textSuccess = Color(0xFF10B981);
  static const Color textWarning = Color(0xFFF59E0B);
  static const Color textError = Color(0xFFEF4444);
  
  // ============================================
  // Border Colors
  // ============================================
  
  static const Color borderBlue = Color(0xFFDBEAFE);
  static const Color borderPurple = Color(0xFFEDE9FE);
  static const Color borderPink = Color(0xFFFCE7F3);
  static const Color borderOrange = Color(0xFFFED7AA);
  static const Color borderGreen = Color(0xFFD1FAE5);
  
  // ============================================
  // Screen-Specific Border Colors for Cards
  // ============================================
  
  static const Color cardBorderHome = Color(0xFFDBEAFE); // blue-100
  static const Color cardBorderPrayer = Color(0xFFFCE7F3); // pink-100
  static const Color cardBorderProgress = Color(0xFFEDE9FE); // purple-100
  static const Color cardBorderHabit = Color(0xFFD1FAE5); // green-100
  static const Color cardBorderPlan = Color(0xFFEDE9FE); // violet-100
}
