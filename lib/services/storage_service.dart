import 'package:shared_preferences/shared_preferences.dart';

import '../models/parking_location.dart';
import '../utils/constants.dart';

class StorageService {
  Future<void> saveParkingLocation(ParkingLocation location) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(AppConstants.savedLatitudeKey, location.latitude);
    await prefs.setDouble(AppConstants.savedLongitudeKey, location.longitude);
    await prefs.setString(AppConstants.savedAddressKey, location.address);
    await prefs.setString(
      AppConstants.savedTimeKey,
      location.savedAt.toIso8601String(),
    );
  }

  Future<ParkingLocation?> getSavedParkingLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final latitude = prefs.getDouble(AppConstants.savedLatitudeKey);
    final longitude = prefs.getDouble(AppConstants.savedLongitudeKey);
    final address = prefs.getString(AppConstants.savedAddressKey);
    final savedTimeString = prefs.getString(AppConstants.savedTimeKey);

    if (latitude == null ||
        longitude == null ||
        address == null ||
        savedTimeString == null) {
      return null;
    }

    return ParkingLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
      savedAt: DateTime.parse(savedTimeString),
    );
  }

  Future<void> clearSavedParkingLocation() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(AppConstants.savedLatitudeKey);
    await prefs.remove(AppConstants.savedLongitudeKey);
    await prefs.remove(AppConstants.savedAddressKey);
    await prefs.remove(AppConstants.savedTimeKey);
  }
}