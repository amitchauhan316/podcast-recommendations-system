import '../models/podcast_model.dart';
import '../models/user_model.dart';

class RecommendationService {

  // 🎯 Main function
  List<Podcast> getRecommendations({
    required UserModel user,
    required List<Podcast> allPodcasts,
  }) {
    List<Podcast> recommended = [];

    // 1️⃣ Match by interests
    for (var podcast in allPodcasts) {
      if (user.interests.contains(podcast.category)) {
        recommended.add(podcast);
      }
    }

    // 2️⃣ Remove already listened podcasts
    recommended = recommended.where((podcast) {
      return !user.history.contains(podcast.id);
    }).toList();

    // 3️⃣ Fallback (if nothing matched)
    if (recommended.isEmpty) {
      recommended = allPodcasts.take(5).toList();
    }

    return recommended;
  }

  // 🔥 Trending (dummy logic)
  List<Podcast> getTrending(List<Podcast> allPodcasts) {
    return allPodcasts.take(5).toList();
  }

  // 🧠 Continue Listening
  List<Podcast> continueListening({
    required UserModel user,
    required List<Podcast> allPodcasts,
  }) {
    return allPodcasts.where((podcast) {
      return user.history.contains(podcast.id);
    }).toList();
  }
}