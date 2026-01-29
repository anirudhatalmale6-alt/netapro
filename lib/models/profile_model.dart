import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String id;
  final String userId;
  final String username; // for custom URL
  final String name;
  final String tagline;
  final String party;
  final String position;
  final String photoUrl;
  final String coverPhotoUrl;
  final String about;
  final String email;
  final String phone;
  final String whatsapp;
  final String address;
  final String templateId;

  // Social links
  final String facebook;
  final String twitter;
  final String instagram;
  final String youtube;

  // Statistics
  final int yearsOfService;
  final int projectsCompleted;
  final int livesImpacted;
  final int volunteers;

  // Collections
  final List<Achievement> achievements;
  final List<String> galleryImages;
  final List<VideoItem> videos;

  // Donation
  final bool donationEnabled;
  final String upiId;
  final String razorpayKey;

  // Analytics
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.name,
    this.tagline = '',
    this.party = '',
    this.position = '',
    this.photoUrl = '',
    this.coverPhotoUrl = '',
    this.about = '',
    this.email = '',
    this.phone = '',
    this.whatsapp = '',
    this.address = '',
    this.templateId = 'modern_blue',
    this.facebook = '',
    this.twitter = '',
    this.instagram = '',
    this.youtube = '',
    this.yearsOfService = 0,
    this.projectsCompleted = 0,
    this.livesImpacted = 0,
    this.volunteers = 0,
    this.achievements = const [],
    this.galleryImages = const [],
    this.videos = const [],
    this.donationEnabled = false,
    this.upiId = '',
    this.razorpayKey = '',
    this.views = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isPublished = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'name': name,
      'tagline': tagline,
      'party': party,
      'position': position,
      'photoUrl': photoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'about': about,
      'email': email,
      'phone': phone,
      'whatsapp': whatsapp,
      'address': address,
      'templateId': templateId,
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'youtube': youtube,
      'yearsOfService': yearsOfService,
      'projectsCompleted': projectsCompleted,
      'livesImpacted': livesImpacted,
      'volunteers': volunteers,
      'achievements': achievements.map((a) => a.toMap()).toList(),
      'galleryImages': galleryImages,
      'videos': videos.map((v) => v.toMap()).toList(),
      'donationEnabled': donationEnabled,
      'upiId': upiId,
      'razorpayKey': razorpayKey,
      'views': views,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isPublished': isPublished,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      tagline: map['tagline'] ?? '',
      party: map['party'] ?? '',
      position: map['position'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      coverPhotoUrl: map['coverPhotoUrl'] ?? '',
      about: map['about'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
      address: map['address'] ?? '',
      templateId: map['templateId'] ?? 'modern_blue',
      facebook: map['facebook'] ?? '',
      twitter: map['twitter'] ?? '',
      instagram: map['instagram'] ?? '',
      youtube: map['youtube'] ?? '',
      yearsOfService: map['yearsOfService'] ?? 0,
      projectsCompleted: map['projectsCompleted'] ?? 0,
      livesImpacted: map['livesImpacted'] ?? 0,
      volunteers: map['volunteers'] ?? 0,
      achievements: (map['achievements'] as List<dynamic>?)
          ?.map((a) => Achievement.fromMap(a))
          .toList() ?? [],
      galleryImages: List<String>.from(map['galleryImages'] ?? []),
      videos: (map['videos'] as List<dynamic>?)
          ?.map((v) => VideoItem.fromMap(v))
          .toList() ?? [],
      donationEnabled: map['donationEnabled'] ?? false,
      upiId: map['upiId'] ?? '',
      razorpayKey: map['razorpayKey'] ?? '',
      views: map['views'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPublished: map['isPublished'] ?? false,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? name,
    String? tagline,
    String? party,
    String? position,
    String? photoUrl,
    String? coverPhotoUrl,
    String? about,
    String? email,
    String? phone,
    String? whatsapp,
    String? address,
    String? templateId,
    String? facebook,
    String? twitter,
    String? instagram,
    String? youtube,
    int? yearsOfService,
    int? projectsCompleted,
    int? livesImpacted,
    int? volunteers,
    List<Achievement>? achievements,
    List<String>? galleryImages,
    List<VideoItem>? videos,
    bool? donationEnabled,
    String? upiId,
    String? razorpayKey,
    int? views,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      party: party ?? this.party,
      position: position ?? this.position,
      photoUrl: photoUrl ?? this.photoUrl,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      about: about ?? this.about,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      address: address ?? this.address,
      templateId: templateId ?? this.templateId,
      facebook: facebook ?? this.facebook,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
      youtube: youtube ?? this.youtube,
      yearsOfService: yearsOfService ?? this.yearsOfService,
      projectsCompleted: projectsCompleted ?? this.projectsCompleted,
      livesImpacted: livesImpacted ?? this.livesImpacted,
      volunteers: volunteers ?? this.volunteers,
      achievements: achievements ?? this.achievements,
      galleryImages: galleryImages ?? this.galleryImages,
      videos: videos ?? this.videos,
      donationEnabled: donationEnabled ?? this.donationEnabled,
      upiId: upiId ?? this.upiId,
      razorpayKey: razorpayKey ?? this.razorpayKey,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String year;
  final String icon;

  Achievement({
    required this.id,
    required this.title,
    this.description = '',
    this.year = '',
    this.icon = 'star',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'year': year,
      'icon': icon,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      year: map['year'] ?? '',
      icon: map['icon'] ?? 'star',
    );
  }
}

class VideoItem {
  final String id;
  final String title;
  final String url;
  final String thumbnailUrl;

  VideoItem({
    required this.id,
    required this.title,
    required this.url,
    this.thumbnailUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory VideoItem.fromMap(Map<String, dynamic> map) {
    return VideoItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
    );
  }
}
