import 'package:flutter/widgets.dart';

/// Responsive breakpoints based on Material 3 window size classes.
///
/// These breakpoints follow Material 3 Guidelines:
/// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
///
/// Window size classes:
/// - Compact: width < 600dp (phones in portrait)
/// - Medium: 600dp ≤ width < 840dp (tablets in portrait, phones in landscape)
/// - Expanded: width ≥ 840dp (tablets in landscape, desktops)
///
/// Usage:
/// ```dart
/// final windowSize = WindowSizeClass.fromContext(context);
/// if (windowSize == WindowSizeClass.compact) {
///   // Single column layout
/// } else {
///   // Multi-column layout
/// }
/// ```
enum WindowSizeClass {
  /// Compact width: < 600dp (phones in portrait)
  compact,

  /// Medium width: 600-839dp (tablets in portrait, phones in landscape)
  medium,

  /// Expanded width: ≥ 840dp (tablets in landscape, desktops)
  expanded;

  /// Determines the window size class from the current build context.
  static WindowSizeClass fromContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return fromWidth(width);
  }

  /// Determines the window size class from a width value.
  static WindowSizeClass fromWidth(double width) {
    if (width < 600) {
      return WindowSizeClass.compact;
    } else if (width < 840) {
      return WindowSizeClass.medium;
    } else {
      return WindowSizeClass.expanded;
    }
  }

  /// Returns true if this is a compact window size class.
  bool get isCompact => this == WindowSizeClass.compact;

  /// Returns true if this is a medium window size class.
  bool get isMedium => this == WindowSizeClass.medium;

  /// Returns true if this is an expanded window size class.
  bool get isExpanded => this == WindowSizeClass.expanded;

  /// Returns true if this is medium or expanded (not compact).
  bool get isWide =>
      this == WindowSizeClass.medium || this == WindowSizeClass.expanded;
}

/// Extension on BuildContext for convenient access to window size class.
extension ResponsiveBreakpointsContext on BuildContext {
  /// Gets the current window size class.
  WindowSizeClass get windowSizeClass => WindowSizeClass.fromContext(this);

  /// Returns true if the current window size is compact.
  bool get isCompactWidth => windowSizeClass.isCompact;

  /// Returns true if the current window size is medium.
  bool get isMediumWidth => windowSizeClass.isMedium;

  /// Returns true if the current window size is expanded.
  bool get isExpandedWidth => windowSizeClass.isExpanded;

  /// Returns true if the current window size is medium or expanded.
  bool get isWideWidth => windowSizeClass.isWide;
}
