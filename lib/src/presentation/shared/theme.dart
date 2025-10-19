import 'package:flutter/material.dart';

/// Application theme definitions following Material 3 design system.
///
/// Adheres to the Design Principles & UI/UX conventions defined in project.md:
/// - Primary color: Indigo (seed color for Material 3 ColorScheme)
/// - Supports light and dark themes with WCAG 2.1 AA contrast
/// - Typography follows Material 3 type scale
/// - Semantic colors for consistent status/feedback display
class MyTheme {
  // Font weight constants for consistent usage across the app
  // Use these instead of raw FontWeight values
  static const FontWeight kRegular = FontWeight.w400; // Body text
  static const FontWeight kMedium = FontWeight.w500; // Emphasized text, labels
  static const FontWeight kBold = FontWeight.w700; // Headlines, important info

  /// Creates the light theme following Material 3 guidelines.
  ///
  /// - Primary colors derived from indigo seed color
  /// - Meets WCAG 2.1 AA contrast requirements (4.5:1 for normal text)
  /// - Uses Material 3 type scale for typography
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,

      // Typography theme following Material 3 type scale
      textTheme: _buildTextTheme(colorScheme),

      // Semantic colors for status and feedback
      // These extend the base color scheme with standardized colors
      extensions: [_SemanticColors.light()],
    );
  }

  /// Creates the dark theme following Material 3 guidelines.
  ///
  /// - Automatically adapts colors for dark mode
  /// - Meets WCAG 2.1 AA contrast requirements
  /// - Uses same typography scale as light theme
  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      // Typography theme following Material 3 type scale
      textTheme: _buildTextTheme(colorScheme),

      // Semantic colors for status and feedback
      extensions: [_SemanticColors.dark()],
    );
  }

  /// Builds text theme following Material 3 type scale.
  ///
  /// Hierarchy:
  /// - Display (Large/Medium/Small): Hero content and major headings
  /// - Headline (Large/Medium/Small): Section headers
  /// - Title (Large/Medium/Small): Card titles and list headers
  /// - Body (Large/Medium/Small): Content text
  /// - Label (Large/Medium/Small): Buttons and labels
  ///
  /// Accessibility:
  /// - Minimum body text: 14sp
  /// - Line height: 1.4-1.6x font size
  /// - Supports text scaling up to 200%
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display styles - Hero content
      displayLarge: TextStyle(
        fontSize: 57,
        height: 1.12,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        height: 1.16,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        height: 1.22,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),

      // Headline styles - Section headers
      headlineLarge: TextStyle(
        fontSize: 32,
        height: 1.25,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.29,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 1.33,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),

      // Title styles - Card titles and list headers
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.27,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.50,
        fontWeight: kMedium,
        color: colorScheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: kMedium,
        color: colorScheme.onSurface,
      ),

      // Body styles - Content text (minimum 14sp for accessibility)
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.50,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.33,
        fontWeight: kRegular,
        color: colorScheme.onSurface,
      ),

      // Label styles - Buttons and labels
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: kMedium,
        color: colorScheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.33,
        fontWeight: kMedium,
        color: colorScheme.onSurface,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        height: 1.45,
        fontWeight: kMedium,
        color: colorScheme.onSurface,
      ),
    );
  }
}

/// Semantic colors for consistent status and feedback display.
///
/// These colors supplement the Material 3 ColorScheme with standardized
/// colors for success, error, warning, and info states. Use these instead
/// of hardcoded colors to ensure:
/// - Consistent visual language across the app
/// - Proper contrast in both light and dark themes
/// - WCAG 2.1 AA compliance (3:1 minimum for interactive elements)
///
/// Usage:
/// ```dart
/// final semanticColors = Theme.of(context).extension<_SemanticColors>()!;
/// Container(color: semanticColors.success)
/// ```
class _SemanticColors extends ThemeExtension<_SemanticColors> {
  final Color success;
  final Color error;
  final Color warning;
  final Color info;
  final Color accent; // Secondary accent for analytics/data visualization

  const _SemanticColors({
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.accent,
  });

  /// Light theme semantic colors (Material 3 green/red/orange/blue tones)
  factory _SemanticColors.light() {
    return const _SemanticColors(
      success: Color(0xFF2E7D32), // Green 800 - WCAG AA compliant
      error: Color(0xFFC62828), // Red 800 - WCAG AA compliant
      warning: Color(0xFFEF6C00), // Orange 800 - WCAG AA compliant
      info: Color(0xFF1565C0), // Blue 800 - WCAG AA compliant
      accent: Color(0xFF6A1B9A), // Purple 800 - for charts/analytics
    );
  }

  /// Dark theme semantic colors (lighter tones for dark backgrounds)
  factory _SemanticColors.dark() {
    return const _SemanticColors(
      success: Color(0xFF81C784), // Green 300 - WCAG AA compliant on dark
      error: Color(0xFFE57373), // Red 300 - WCAG AA compliant on dark
      warning: Color(0xFFFFB74D), // Orange 300 - WCAG AA compliant on dark
      info: Color(0xFF64B5F6), // Blue 300 - WCAG AA compliant on dark
      accent: Color(0xFFBA68C8), // Purple 300 - for charts/analytics
    );
  }

  @override
  ThemeExtension<_SemanticColors> copyWith({
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Color? accent,
  }) {
    return _SemanticColors(
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      accent: accent ?? this.accent,
    );
  }

  @override
  ThemeExtension<_SemanticColors> lerp(
    ThemeExtension<_SemanticColors>? other,
    double t,
  ) {
    if (other is! _SemanticColors) return this;
    return _SemanticColors(
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
