import 'package:flutter/material.dart';

class AppConstants {
  static const String appTitle = 'Park Mark';

  static const String savedLatitudeKey = 'saved_latitude';
  static const String savedLongitudeKey = 'saved_longitude';
  static const String savedAddressKey = 'saved_address';
  static const String savedTimeKey = 'saved_time';

  static const String googleMapsSearchBaseUrl =
      'https://www.google.com/maps/search/?api=1&query=';

  static const String locationSavedSuccess =
      'Vehicle location saved successfully.';
  static const String locationClearedSuccess =
      'Saved vehicle location cleared.';
  static const String locationPermissionDenied =
      'Location permission denied. Please allow location access.';
  static const String locationPermissionDeniedForever =
      'Location permission is permanently denied. Enable it from device settings.';
  static const String locationServiceDisabled =
      'Location services are disabled. Please enable GPS.';
  static const String mapsLaunchError = 'Could not open Google Maps.';
  static const String settingsOpenError = 'Could not open device settings.';
  static const String addressUnavailable = 'Address not available';
}

class AppColors {
  static const Color background = Color(0xFF0D5A60);
  static const Color primary = Color(0xFF0D5A60);
  static const Color accent = Color(0xFFFF4D2D);
  static const Color card = Color(0xFFF3F4F6);
  static const Color cardIcon = Color(0xFF111827);
  static const Color brandPlate = Color(0xFFF7F3EA);
  static const Color sliderTrack = Color(0xFF5A8890);
  static const Color success = Color(0xFF1E9E6A);
  static const Color danger = Color(0xFFC94242);
  static const Color secondaryButton = Color(0xFF6B7280);
}

class AppTextStyles {
  static const TextStyle brandTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Color(0xFF111827),
    letterSpacing: 1.4,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF111827),
    letterSpacing: 0.4,
  );

  static const TextStyle cardBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF374151),
    height: 1.45,
  );

  static const TextStyle savedTime = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7280),
  );

  static const TextStyle sliderText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.8,
  );

  static const TextStyle detailLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7280),
  );

  static const TextStyle detailValue = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Color(0xFF111827),
    height: 1.4,
  );
}