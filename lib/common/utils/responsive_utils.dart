import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive utilities for handling different screen sizes and orientations
class ResponsiveUtils {
  const ResponsiveUtils._();

  /// Breakpoints for different screen sizes
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide < tabletBreakpoint;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= tabletBreakpoint && shortestSide < desktopBreakpoint;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= desktopBreakpoint;
  }

  /// Get grid column count based on screen size and orientation
  static int getGridColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLandscapeMode = isLandscape(context);

    if (width < mobileBreakpoint) {
      return isLandscapeMode ? 3 : 2;
    } else if (width < tabletBreakpoint) {
      return isLandscapeMode ? 4 : 2;
    } else if (width < desktopBreakpoint) {
      return isLandscapeMode ? 5 : 3;
    } else {
      return isLandscapeMode ? 6 : 4;
    }
  }

  /// Get adaptive padding based on screen size
  static EdgeInsets getAdaptivePadding(BuildContext context) {
    if (isMobile(context)) {
      return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
    } else {
      return EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h);
    }
  }

  /// Get card aspect ratio based on orientation
  static double getCardAspectRatio(BuildContext context) {
    return isLandscape(context) ? 0.85 : 0.75;
  }

  /// Get detail page layout based on orientation
  static bool useWideLayout(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint || isLandscape(context);
  }
}

/// Extension for responsive sizing
extension ResponsiveExtension on num {
  /// Responsive width
  double get rw => w;

  /// Responsive height
  double get rh => h;

  /// Responsive font size
  double get rsp => sp;

  /// Responsive radius
  double get rr => r;
}
