import '../../models/podcast_model.dart';
import '../../services/api_service.dart';
import '../../services/user_state.dart';

class FilterAttributes {
  final List<String> categories;
  final int maxDuration;
  final int minRating;

  const FilterAttributes({
    this.categories = const [],
    this.maxDuration = 120,
    this.minRating = 0,
  });

  bool get isEmpty => categories.isEmpty && maxDuration >= 120 && minRating == 0;
}

class SearchController {
  final ApiService _apiService = ApiService();

  List<Podcast> searchResults = [];
  String currentQuery = "";
  bool isLoading = false;

  Future<void> loadInitial({FilterAttributes filters = const FilterAttributes()}) async {
    await search("", filters: filters);
  }

  Future<void> search(String query, {FilterAttributes filters = const FilterAttributes()}) async {
    currentQuery = query.trim();
    isLoading = true;
    try {
      searchResults = await _apiService.searchPodcasts(
        currentQuery,
        categories: filters.categories,
        maxDuration: filters.maxDuration,
        minRating: filters.minRating,
        excludedIds: UserState().excludedIds,
      );
    } catch (e) {
      searchResults = [];
    } finally {
      isLoading = false;
    }
  }
}
