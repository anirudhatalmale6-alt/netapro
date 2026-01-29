// Demo Profile Service - Works with local data for testing
import '../models/profile_model.dart';

class DemoProfileService {
  static final Map<String, ProfileModel> _profiles = {};
  static bool _initialized = false;

  static void _initDemoData() {
    if (_initialized) return;
    _initialized = true;

    // Add sample profile
    final sampleProfile = ProfileModel(
      id: 'sample_profile_1',
      userId: 'demo_user_123',
      username: 'rajeshkumar',
      name: 'Rajesh Kumar',
      tagline: 'Building a Stronger Tomorrow',
      party: 'Bhartiya Janata Party',
      position: 'MLA - Ward 45',
      about: 'Dedicated public servant with 15+ years of experience in grassroots politics. My vision focuses on Education for All, Sustainable Development, and Youth Empowerment. I believe in transparent governance and inclusive growth for all communities.',
      email: 'rajesh@example.com',
      phone: '+91 98765 43210',
      whatsapp: '+919876543210',
      address: '123, Gandhi Nagar, New Delhi - 110001',
      templateId: 'modern_blue',
      facebook: 'https://facebook.com/rajeshkumar',
      twitter: 'https://twitter.com/rajeshkumar',
      instagram: 'https://instagram.com/rajeshkumar',
      youtube: 'https://youtube.com/rajeshkumar',
      yearsOfService: 15,
      projectsCompleted: 120,
      livesImpacted: 50000,
      volunteers: 500,
      achievements: [
        Achievement(
          id: '1',
          title: 'Clean Water Initiative',
          description: 'Provided clean drinking water to 10,000+ households',
          year: '2023',
        ),
        Achievement(
          id: '2',
          title: 'Skill Development Center',
          description: 'Established training center for unemployed youth',
          year: '2022',
        ),
        Achievement(
          id: '3',
          title: 'Health Camp Program',
          description: 'Organized 50+ free health camps in rural areas',
          year: '2021',
        ),
      ],
      donationEnabled: true,
      upiId: 'rajeshkumar@upi',
      views: 1234,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
      isPublished: true,
    );

    _profiles[sampleProfile.id] = sampleProfile;
  }

  Future<ProfileModel> createProfile(ProfileModel profile) async {
    _initDemoData();
    await Future.delayed(const Duration(milliseconds: 300));
    _profiles[profile.id] = profile;
    return profile;
  }

  Future<void> updateProfile(ProfileModel profile) async {
    _initDemoData();
    await Future.delayed(const Duration(milliseconds: 300));
    _profiles[profile.id] = profile;
  }

  Future<void> deleteProfile(String profileId) async {
    _initDemoData();
    await Future.delayed(const Duration(milliseconds: 300));
    _profiles.remove(profileId);
  }

  Future<ProfileModel?> getProfile(String profileId) async {
    _initDemoData();
    await Future.delayed(const Duration(milliseconds: 200));
    return _profiles[profileId];
  }

  Future<ProfileModel?> getProfileByUsername(String username) async {
    _initDemoData();
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _profiles.values.firstWhere(
        (p) => p.username.toLowerCase() == username.toLowerCase() && p.isPublished,
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    _initDemoData();
    await Future.delayed(const Duration(milliseconds: 200));
    return !_profiles.values.any(
      (p) => p.username.toLowerCase() == username.toLowerCase(),
    );
  }

  List<ProfileModel> getUserProfiles(String userId) {
    _initDemoData();
    return _profiles.values.where((p) => p.userId == userId).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> incrementViews(String profileId) async {
    _initDemoData();
    final profile = _profiles[profileId];
    if (profile != null) {
      _profiles[profileId] = profile.copyWith(views: profile.views + 1);
    }
  }

  Future<Map<String, int>> getUserStats(String userId) async {
    _initDemoData();
    final userProfiles = _profiles.values.where((p) => p.userId == userId).toList();

    int totalViews = 0;
    int publishedProfiles = 0;

    for (var profile in userProfiles) {
      totalViews += profile.views;
      if (profile.isPublished) publishedProfiles++;
    }

    return {
      'totalProfiles': userProfiles.length,
      'totalViews': totalViews,
      'publishedProfiles': publishedProfiles,
    };
  }
}
