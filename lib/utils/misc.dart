import 'dart:math';

import 'package:demo25/utils/slugify.dart' as slugify;
import 'package:demo25/versioning/build_version.dart';
import 'package:flutter/material.dart'
    show BuildContext, MediaQuery, ScaffoldMessenger, SnackBar, Text;
import 'package:flutter/services.dart';

class Misc {
  Misc._();

  static String getUserNameInitials(String userName, {int maxInitials = 2}) {
    final trimmedName = userName.trim();
    if (trimmedName.isEmpty) return 'U';

    final words = trimmedName.split(RegExp(r'\s+'));
    final initials = StringBuffer();

    for (var i = 0; i < min(words.length, maxInitials); i++) {
      if (words[i].isNotEmpty) {
        initials.write(words[i][0].toUpperCase());
      }
    }

    return initials.isEmpty ? 'U' : initials.toString();
  }

  static String getFullAppVersion() {
    try {
      return packageVersion.trim();
    } catch (e) {
      return '0.0.0'; // Fallback version
    }
  }

  static String getAppVersion() {
    try {
      final version = packageVersion.trim();
      return version.length > 7 ? version.substring(0, 7) : version;
    } catch (e) {
      return '0.0.0';
    }
  }

  static String getSluggedAppVersion() {
    try {
      return slugify.slugify(getAppVersion());
    } catch (e) {
      return '0-0-0';
    }
  }

  static double getScaleFactor(
    BuildContext context, {
    double? customBaseWidth,
    double? minScale,
    double? maxScale,
  }) {
    try {
      final screenWidth = MediaQuery.of(context).size.width;
      final deviceType = getDeviceType(context);

      // Dynamic base widths based on device type
      final baseWidth =
          customBaseWidth ??
          switch (deviceType) {
            DeviceType.phone => 375.0,
            DeviceType.tablet => 600.0,
            DeviceType.desktop => 1200.0,
          };

      final scaleFactor = screenWidth / baseWidth;

      // Dynamic scale ranges based on device type
      final minScaleValue =
          minScale ??
          switch (deviceType) {
            DeviceType.phone => 0.8,
            DeviceType.tablet => 0.7,
            DeviceType.desktop => 0.6,
          };

      final maxScaleValue =
          maxScale ??
          switch (deviceType) {
            DeviceType.phone => 1.4,
            DeviceType.tablet => 1.6,
            DeviceType.desktop => 2.0,
          };

      return scaleFactor.clamp(minScaleValue, maxScaleValue);
    } catch (e) {
      return 1; // Fallback to no scaling
    }
  }

  /// Get device type based on screen size
  static DeviceType getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200) return DeviceType.desktop;
    if (screenWidth >= 600) return DeviceType.tablet;
    return DeviceType.phone;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height;
  }

  // Static variable to track last back press across all instances
  static DateTime? _lastBackPressed;

  static Future<void> exitApp({
    required BuildContext context,
    required bool didPop,
    required Object? result,
    String? exitMessage,
    Duration? timeWindow,
  }) async {
    if (didPop) return;

    final now = DateTime.now();
    final window = timeWindow ?? const Duration(seconds: 2);
    final message = exitMessage ?? 'Press back again to exit';

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > window) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), duration: window));
    } else {
      await SystemNavigator.pop();
    }
  }
}

/// Device type enumeration
enum DeviceType { phone, tablet, desktop }
