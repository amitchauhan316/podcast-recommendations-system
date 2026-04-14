class UserModel {
  final String id;
  final String name;
  final String email;

  // 🎧 Interests (from onboarding)
  final List<String> interests;

  // ❤️ Saved / liked podcasts
  final List<String> likedPodcasts;

  // ⏱ Listening history (podcast IDs)
  final List<String> history;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.interests = const [],
    this.likedPodcasts = const [],
    this.history = const [],
  });

  // 🔄 Convert to JSON (for backend)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "interests": interests,
      "likedPodcasts": likedPodcasts,
      "history": history,
    };
  }

  // 🔄 Create from JSON (API ready)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      interests: List<String>.from(json['interests'] ?? []),
      likedPodcasts: List<String>.from(json['likedPodcasts'] ?? []),
      history: List<String>.from(json['history'] ?? []),
    );
  }
}