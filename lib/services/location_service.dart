import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/parking_location.dart';
import '../utils/constants.dart';

class LocationService {
  Future<ParkingLocation> getCurrentParkingLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(AppConstants.locationServiceDisabled);
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception(AppConstants.locationPermissionDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(AppConstants.locationPermissionDeniedForever);
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final String address = await _getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return ParkingLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      savedAt: DateTime.now(),
    );
  }

  Future<String> _getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return AppConstants.addressUnavailable;
      }

      final place = placemarks.first;

      final parts = <String?>[
        place.name,
        place.street,
        place.locality,
        place.administrativeArea,
        place.country,
      ];

      final cleaned = parts
          .where((part) => part != null && part.trim().isNotEmpty)
          .cast<String>()
          .toList();

      if (cleaned.isEmpty) {
        return AppConstants.addressUnavailable;
      }

      return cleaned.join(', ');
    } catch (_) {
      return AppConstants.addressUnavailable;
    }
  }
}