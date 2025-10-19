import 'package:flutter/widgets.dart';
import 'package:app/src/presentation/shared/utils/responsive_breakpoints.dart';

/// A responsive container that adapts its content based on window size class.
///
/// This widget follows Material 3 responsive design guidelines and provides
/// different builders for compact, medium, and expanded window sizes.
///
/// At minimum, you must provide a [compact] builder. If [medium] or [expanded]
/// builders are not provided, they will fall back to the next smaller size.
///
/// Usage:
/// ```dart
/// ResponsiveContainer(
///   compact: (context) => SingleColumnLayout(),
///   medium: (context) => TwoColumnLayout(),
///   expanded: (context) => ThreeColumnLayout(),
/// )
/// ```
class ResponsiveContainer extends StatelessWidget {
  /// Builder for compact window size (< 600dp).
  final WidgetBuilder compact;

  /// Builder for medium window size (600-839dp).
  /// Falls back to [compact] if not provided.
  final WidgetBuilder? medium;

  /// Builder for expanded window size (≥ 840dp).
  /// Falls back to [medium] or [compact] if not provided.
  final WidgetBuilder? expanded;

  const ResponsiveContainer({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    final windowSize = context.windowSizeClass;

    switch (windowSize) {
      case WindowSizeClass.compact:
        return compact(context);
      case WindowSizeClass.medium:
        return (medium ?? compact)(context);
      case WindowSizeClass.expanded:
        return (expanded ?? medium ?? compact)(context);
    }
  }
}

/// A responsive widget that provides the current window size class to its builder.
///
/// Useful when you need to make conditional decisions based on window size
/// within a single builder function.
///
/// Usage:
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, windowSize) {
///     if (windowSize.isCompact) {
///       return SingleColumnWidget();
///     }
///     return MultiColumnWidget();
///   },
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Builder function that receives the window size class.
  final Widget Function(BuildContext context, WindowSizeClass windowSize)
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, context.windowSizeClass);
  }
}

/// A responsive padding widget that adapts padding based on window size class.
///
/// Follows Material 3 spacing guidelines with different padding values for
/// different screen sizes:
/// - Compact: 16dp horizontal padding
/// - Medium: 24dp horizontal padding
/// - Expanded: 32dp horizontal padding
///
/// You can customize these values by providing your own padding configurations.
///
/// Usage:
/// ```dart
/// ResponsivePadding(
///   child: MyContent(),
/// )
/// ```
class ResponsivePadding extends StatelessWidget {
  /// The child widget to wrap with responsive padding.
  final Widget child;

  /// Padding for compact window size. Defaults to 16dp horizontal.
  final EdgeInsetsGeometry? compactPadding;

  /// Padding for medium window size. Defaults to 24dp horizontal.
  final EdgeInsetsGeometry? mediumPadding;

  /// Padding for expanded window size. Defaults to 32dp horizontal.
  final EdgeInsetsGeometry? expandedPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.compactPadding,
    this.mediumPadding,
    this.expandedPadding,
  });

  @override
  Widget build(BuildContext context) {
    final windowSize = context.windowSizeClass;

    EdgeInsetsGeometry padding;
    switch (windowSize) {
      case WindowSizeClass.compact:
        padding = compactPadding ?? const EdgeInsets.symmetric(horizontal: 16);
        break;
      case WindowSizeClass.medium:
        padding = mediumPadding ?? const EdgeInsets.symmetric(horizontal: 24);
        break;
      case WindowSizeClass.expanded:
        padding = expandedPadding ?? const EdgeInsets.symmetric(horizontal: 32);
        break;
    }

    return Padding(padding: padding, child: child);
  }
}

/// A responsive center widget that constrains content width on wide screens.
///
/// On compact screens, uses full width. On medium and expanded screens,
/// constrains the content to a maximum width to maintain readability.
///
/// Follows Material 3 guidelines for content width constraints:
/// - Compact: No constraint (full width)
/// - Medium: Max 840dp
/// - Expanded: Max 1200dp (or custom maxWidth)
///
/// Usage:
/// ```dart
/// ResponsiveCenter(
///   child: MyContent(),
/// )
/// ```
class ResponsiveCenter extends StatelessWidget {
  /// The child widget to center and constrain.
  final Widget child;

  /// Maximum width for the content on expanded screens. Defaults to 1200dp.
  final double maxWidth;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    final windowSize = context.windowSizeClass;

    if (windowSize.isCompact) {
      // No constraint on compact screens
      return child;
    }

    // Constrain width on medium and expanded screens
    final constraintWidth = windowSize.isMedium ? 840.0 : maxWidth;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraintWidth),
        child: child,
      ),
    );
  }
}
