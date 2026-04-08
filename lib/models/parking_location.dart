class ParkingLocation {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime savedAt;

  ParkingLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory ParkingLocation.fromMap(Map<String, dynamic> map) {
    return ParkingLocation(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      address: map['address'] as String,
      savedAt: DateTime.parse(map['savedAt'] as String),
    );
  }
}