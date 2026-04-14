import '../../models/podcast_model.dart';
import '../../services/api_service.dart';
import '../../services/user_state.dart';

class HomeController {
  final ApiService _apiService = ApiService();

  Future<List<Podcast>> getRecommended() async {
    return await _apiService.fetchRecommendations(UserState().selectedCategories, excludedIds: UserState().excludedIds);
  }

  Future<List<Podcast>> getTrending() async {
    // Top 50 podcasts as trending
    return await _apiService.fetchPodcasts();
  }
}