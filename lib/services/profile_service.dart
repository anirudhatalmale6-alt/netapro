import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _profiles => _firestore.collection('profiles');

  // Create a new profile
  Future<ProfileModel> createProfile(ProfileModel profile) async {
    final docRef = _profiles.doc(profile.id);
    await docRef.set(profile.toMap());
    return profile;
  }

  // Update profile
  Future<void> updateProfile(ProfileModel profile) async {
    await _profiles.doc(profile.id).update(profile.toMap());
  }

  // Delete profile
  Future<void> deleteProfile(String profileId) async {
    await _profiles.doc(profileId).delete();
  }

  // Get profile by ID
  Future<ProfileModel?> getProfile(String profileId) async {
    final doc = await _profiles.doc(profileId).get();
    if (doc.exists) {
      return ProfileModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Get profile by username (for custom URL)
  Future<ProfileModel?> getProfileByUsername(String username) async {
    final query = await _profiles
        .where('username', isEqualTo: username.toLowerCase())
        .where('isPublished', isEqualTo: true)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return ProfileModel.fromMap(query.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    final query = await _profiles
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();
    return query.docs.isEmpty;
  }

  // Get all profiles for a user
  Stream<List<ProfileModel>> getUserProfiles(String userId) {
    return _profiles
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProfileModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Increment view count
  Future<void> incrementViews(String profileId) async {
    await _profiles.doc(profileId).update({
      'views': FieldValue.increment(1),
    });
  }

  // Get total stats for a user
  Future<Map<String, int>> getUserStats(String userId) async {
    final query = await _profiles.where('userId', isEqualTo: userId).get();

    int totalProfiles = query.docs.length;
    int totalViews = 0;
    int publishedProfiles = 0;

    for (var doc in query.docs) {
      final data = doc.data() as Map<String, dynamic>;
      totalViews += (data['views'] ?? 0) as int;
      if (data['isPublished'] == true) {
        publishedProfiles++;
      }
    }

    return {
      'totalProfiles': totalProfiles,
      'totalViews': totalViews,
      'publishedProfiles': publishedProfiles,
    };
  }
}
