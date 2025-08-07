// lib/config/build_config.dart - Build configuration
import 'package:flutter/foundation.dart';

class BuildConfig {
  static const bool isDebug = kDebugMode;
  static const bool isRelease = kReleaseMode;
  static const bool isProfile = kProfileMode;
  
  // Check if running in a build environment (CI/CD, production build, etc.)
  static bool get isBuildEnvironment {
    return isRelease || isProfile || const bool.fromEnvironment('BUILD_ENV', defaultValue: false);
  }
  
  // Check if we should use fallback data
  static bool get shouldUseFallbackData {
    return isBuildEnvironment || const bool.fromEnvironment('USE_FALLBACK_DATA', defaultValue: false);
  }
  
  // API timeout settings
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration apiRetryDelay = Duration(seconds: 2);
  static const int maxRetryAttempts = 3;
  
  // Image loading settings
  static const Duration imageTimeout = Duration(seconds: 15);
  static const bool enableImageCaching = true;
  static const bool enableImageRetry = true;
  
  // Debug settings
  static const bool enableApiLogging = isDebug;
  static const bool enableImageLogging = isDebug;
  
  // Fallback image URLs for when NASA API is unavailable
  static const List<String> fallbackImageUrls = [
    'https://images-assets.nasa.gov/image/PIA23645/PIA23645~orig.jpg',
    'https://images-assets.nasa.gov/image/PIA23646/PIA23646~orig.jpg',
    'https://images-assets.nasa.gov/image/PIA23647/PIA23647~orig.jpg',
    'https://images-assets.nasa.gov/image/PIA23648/PIA23648~orig.jpg',
    'https://images-assets.nasa.gov/image/PIA23649/PIA23649~orig.jpg',
    'https://images-assets.nasa.gov/image/PIA23650/PIA23650~orig.jpg',
  ];
  
  // Get a random fallback image URL
  static String getRandomFallbackImage() {
    final random = DateTime.now().millisecond % fallbackImageUrls.length;
    return fallbackImageUrls[random];
  }
} 