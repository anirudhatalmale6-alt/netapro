import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  List<ProfileModel> _profiles = [];
  ProfileModel? _currentProfile;
  bool _isLoading = false;
  String? _error;
  Map<String, int> _stats = {};

  List<ProfileModel> get profiles => _profiles;
  ProfileModel? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, int> get stats => _stats;

  void listenToUserProfiles(String userId) {
    _profileService.getUserProfiles(userId).listen((profiles) {
      _profiles = profiles;
      notifyListeners();
    });
  }

  Future<void> loadUserStats(String userId) async {
    _stats = await _profileService.getUserStats(userId);
    notifyListeners();
  }

  Future<ProfileModel?> createProfile(ProfileModel profile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final created = await _profileService.createProfile(profile);
      _isLoading = false;
      notifyListeners();
      return created;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateProfile(ProfileModel profile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _profileService.updateProfile(profile);
      _currentProfile = profile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProfile(String profileId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _profileService.deleteProfile(profileId);
      _profiles.removeWhere((p) => p.id == profileId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<ProfileModel?> loadProfile(String profileId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentProfile = await _profileService.getProfile(profileId);
      _isLoading = false;
      notifyListeners();
      return _currentProfile;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<ProfileModel?> loadProfileByUsername(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentProfile = await _profileService.getProfileByUsername(username);
      if (_currentProfile != null) {
        // Increment view count
        await _profileService.incrementViews(_currentProfile!.id);
      }
      _isLoading = false;
      notifyListeners();
      return _currentProfile;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    return await _profileService.isUsernameAvailable(username);
  }

  void setCurrentProfile(ProfileModel? profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
