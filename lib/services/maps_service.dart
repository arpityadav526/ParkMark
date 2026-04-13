import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';

class MapsService {
  Future<void> openInGoogleMaps({
    required double latitude,
    required double longitude,
  }) async {
    final Uri androidNavigationUri =
        Uri.parse('google.navigation:q=$latitude,$longitude');

    final Uri iosGoogleMapsUri = Uri.parse(
      'comgooglemaps://?q=$latitude,$longitude&directionsmode=driving',
    );

    final Uri webFallbackUri = Uri.parse(
      '${AppConstants.googleMapsSearchBaseUrl}$latitude,$longitude',
    );

    try {
      if (Platform.isAndroid) {
        final launched = await launchUrl(
          androidNavigationUri,
          mode: LaunchMode.externalApplication,
        );

        if (launched) return;
      }

      if (Platform.isIOS) {
        final launched = await launchUrl(
          iosGoogleMapsUri,
          mode: LaunchMode.externalApplication,
        );

        if (launched) return;
      }

      final fallbackLaunched = await launchUrl(
        webFallbackUri,
        mode: LaunchMode.externalApplication,
      );

      if (!fallbackLaunched) {
        throw Exception(AppConstants.mapsLaunchError);
      }
    } catch (_) {
      final fallbackLaunched = await launchUrl(
        webFallbackUri,
        mode: LaunchMode.externalApplication,
      );

      if (!fallbackLaunched) {
        throw Exception(AppConstants.mapsLaunchError);
      }
    }
  }

  Future<void> openAppSettings() async {
    final opened = await Geolocator.openAppSettings();
    if (!opened) {
      throw Exception(AppConstants.settingsOpenError);
    }
  }

  Future<void> openLocationSettings() async {
    final opened = await Geolocator.openLocationSettings();
    if (!opened) {
      throw Exception(AppConstants.settingsOpenError);
    }
  }
}