import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/parking_location.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrUpdateUserProfile(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);

    await docRef.set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveParkingLocationForUser({
    required String uid,
    required ParkingLocation location,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('parking_locations')
        .add({
      'latitude': location.latitude,
      'longitude': location.longitude,
      'address': location.address,
      'savedAt': location.savedAt.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}