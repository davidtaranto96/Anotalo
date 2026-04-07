import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Extension on BuildContext to get theme-aware colors.
/// Usage: `context.surfaceBase` instead of `AppTheme.surfaceBase`
extension AppColors on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  // Surfaces
  Color get surfaceBase => _isDark ? AppTheme.darkSurfaceBase : AppTheme.surfaceBase;
  Color get surfaceCard => _isDark ? AppTheme.darkSurfaceCard : AppTheme.surfaceCard;
  Color get surfaceElevated => _isDark ? AppTheme.darkSurfaceElevated : AppTheme.surfaceElevated;
  Color get surfaceSheet => _isDark ? AppTheme.darkSurfaceSheet : AppTheme.surfaceSheet;
  Color get surfaceInput => _isDark ? AppTheme.darkSurfaceInput : AppTheme.surfaceInput;
  Color get dividerColor => _isDark ? AppTheme.darkDivider : AppTheme.divider;

  // Text
  Color get textPrimary => _isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
  Color get textSecondary => _isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
  Color get textTertiary => _isDark ? AppTheme.darkTextTertiary : AppTheme.textTertiary;

  // Brand (slightly brighter in dark mode)
  Color get colorPrimary => _isDark ? AppTheme.darkColorPrimary : AppTheme.colorPrimary;
  Color get colorAccent => _isDark ? AppTheme.darkColorAccent : AppTheme.colorAccent;

  // Neutrals (inverted for dark mode)
  Color get neutral50 => _isDark ? const Color(0xFF2A2A2F) : AppTheme.neutral50;
  Color get neutral100 => _isDark ? const Color(0xFF323238) : AppTheme.neutral100;
  Color get neutral200 => _isDark ? const Color(0xFF3A3A40) : AppTheme.neutral200;
  Color get neutral300 => _isDark ? const Color(0xFF454550) : AppTheme.neutral300;
  Color get neutral400 => _isDark ? const Color(0xFF666670) : AppTheme.neutral400;
  Color get neutral500 => _isDark ? const Color(0xFF888890) : AppTheme.neutral500;
}
