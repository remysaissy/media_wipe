import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Platform detection utilities for iOS/Android/macOS specific adaptations.
///
/// Provides convenient methods to detect the current platform and adapt
/// UI/UX accordingly following platform-specific design conventions.
///
/// Usage:
/// ```dart
/// if (PlatformUtils.isIOS) {
///   // iOS-specific UI
/// } else if (PlatformUtils.isAndroid) {
///   // Android-specific UI
/// }
/// ```
class PlatformUtils {
  PlatformUtils._(); // Private constructor to prevent instantiation

  /// Returns true if running on iOS (iPhone or iPad).
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Returns true if running on Android (phone or tablet).
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Returns true if running on macOS.
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Returns true if running on any Apple platform (iOS or macOS).
  static bool get isApplePlatform => isIOS || isMacOS;

  /// Returns true if running on a mobile platform (iOS or Android).
  static bool get isMobile => isIOS || isAndroid;

  /// Returns true if running on a desktop platform (macOS, Windows, Linux).
  static bool get isDesktop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  /// Returns true if running on web.
  static bool get isWeb => kIsWeb;

  /// Returns a human-readable platform name.
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}
