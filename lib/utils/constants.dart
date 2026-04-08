class AppConstants {
  static const String appTitle = 'Parked Vehicle Locator';

  static const String savedLatitudeKey = 'saved_latitude';
  static const String savedLongitudeKey = 'saved_longitude';
  static const String savedAddressKey = 'saved_address';
  static const String savedTimeKey = 'saved_time';

  static const String googleMapsSearchBaseUrl =
      'https://www.google.com/maps/search/?api=1&query=';

  static const String homeTitle = 'Save Your Parked Vehicle';
  static const String noLocationSaved = 'No parked vehicle location saved.';
  static const String locationSavedSuccess = 'Vehicle location saved successfully.';
  static const String locationClearedSuccess = 'Saved vehicle location cleared.';
  static const String locationPermissionDenied =
      'Location permission denied. Please allow location access.';
  static const String locationServiceDisabled =
      'Location services are disabled. Please enable GPS.';
  static const String locationFetchError =
      'Unable to fetch current location.';
  static const String noSavedLocationFound =
      'No saved vehicle location found.';
}