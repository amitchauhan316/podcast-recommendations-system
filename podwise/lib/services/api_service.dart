import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/podcast_model.dart';

class ApiService {
  // 🔗 Replace with the correct backend URL for your environment.
  // For Android emulator use 10.0.2.2, for desktop or iOS simulator use 127.0.0.1.
  static String get baseUrl {
    if (kIsWeb) {
      return "http://10.172.82.11:8000/api";
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.172.82.11:8000/api";
    }
    return "http://10.172.82.11:8000/api";
  }

  // 🎧 Get Podcasts (dummy API for now)
  Future<List<Podcast>> fetchPodcasts() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/podcasts/"));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((e) => Podcast(
          id: e['id'].toString(),
          title: e['title'] ?? "Unknown Title",
          author: e['author'] ?? "Unknown Author",
          imageUrl: e['image'] ?? "https://picsum.photos/200",
          audioUrl: e['audio'] ?? "",
          duration: e['duration'] ?? "0m",
          durationMinutes: e['duration_minutes'] ?? 0,
          category: e['category'] ?? "Other",
          rating: (e['rating'] is num)
              ? (e['rating'] as num).toDouble()
              : double.tryParse((e['rating'] ?? "0").toString()) ?? 0.0,
        )).toList();
      } else {
        throw Exception("Failed to load podcasts");
      }
    } catch (e) {
      // 🧠 fallback (so your app doesn’t die)
      return _dummyPodcasts();
    }
  }

  // 🎯 Fetch Recommendations based on interests
  Future<List<Podcast>> fetchRecommendations(List<String> interests, {List<String>? excludedIds}) async {
    try {
      final body = {
        "interests": interests,
        if (excludedIds != null) "excluded_ids": excludedIds,
      };
      final response = await http.post(
        Uri.parse("$baseUrl/recommend/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((e) => Podcast(
          id: e['id'].toString(),
          title: e['title'] ?? "Unknown Title",
          author: e['author'] ?? "Unknown Author",
          imageUrl: e['image'] ?? "https://picsum.photos/200",
          audioUrl: e['audio'] ?? "",
          duration: e['duration'] ?? "0m",
          durationMinutes: e['duration_minutes'] ?? 0,
          category: e['category'] ?? "Other",
          rating: (e['rating'] is num)
              ? (e['rating'] as num).toDouble()
              : double.tryParse((e['rating'] ?? "0").toString()) ?? 0.0,
        )).toList();
      } else {
        throw Exception("Failed to load recommendations");
      }
    } catch (e) {
      // 🧠 fallback (so your app doesn’t die)
      return _dummyPodcasts();
    }
  }

  // 🔍 Search Podcasts
  Future<List<Podcast>> searchPodcasts(
    String query, {
    List<String>? categories,
    int? maxDuration,
    int? minRating,
    List<String>? excludedIds,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/podcasts/search").replace(queryParameters: {
        "q": query,
        if (categories != null && categories.isNotEmpty) "categories": categories.join(","),
        if (maxDuration != null) "max_duration": maxDuration.toString(),
        if (minRating != null) "min_rating": minRating.toString(),
        if (excludedIds != null && excludedIds.isNotEmpty) "excluded_ids": excludedIds.join(","),
      });
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((e) => Podcast(
          id: e['id'].toString(),
          title: e['title'] ?? "Unknown Title",
          author: e['author'] ?? "Unknown Author",
          imageUrl: e['image'] ?? "https://picsum.photos/200",
          audioUrl: e['audio'] ?? "",
          duration: e['duration'] ?? "0m",
          durationMinutes: e['duration_minutes'] ?? 0,
          category: e['category'] ?? "Other",
          rating: (e['rating'] is num)
              ? (e['rating'] as num).toDouble()
              : double.tryParse((e['rating'] ?? "0").toString()) ?? 0.0,
        )).toList();
      } else {
        throw Exception("Failed to search podcasts");
      }
    } catch (e) {
      // 🧠 fallback (so your app doesn’t die)
      return _dummyPodcasts();
    }
  }

  // 🧪 Dummy Data (fallback)
  List<Podcast> _dummyPodcasts() {
    return [
      Podcast(
        id: "1",
        title: "Future of AI",
        author: "Lex Fridman",
        imageUrl: "https://picsum.photos/200",
        audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        duration: "3h 12m",
        category: "Technology",
      ),
      Podcast(
        id: "2",
        title: "The Daily",
        author: "NY Times",
        imageUrl: "https://picsum.photos/201",
        audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        duration: "25m",
        category: "News",
      ),
    ];
  }

  // 📚 Library API methods
  Future<List<Map<String, dynamic>>> fetchSubscribedEpisodes() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/library/subscribed"));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        throw Exception("Failed to load subscribed episodes");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchSavedEpisodes() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/library/saved"));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        throw Exception("Failed to load saved episodes");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchDownloadedEpisodes() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/library/downloaded"));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        throw Exception("Failed to load downloaded episodes");
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> playEpisode(String episodeId, Map<String, dynamic> episodeData) async {
    try {
      final body = {
        "episode_id": episodeId,
        "episode": episodeData,
      };
      await http.post(
        Uri.parse("$baseUrl/library/play"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
    } catch (e) {
      // Ignore errors for now
    }
  }

  Future<void> subscribeEpisode(Map<String, dynamic> episode) async {
    try {
      final body = {"episode": episode};
      await http.post(
        Uri.parse("$baseUrl/library/subscribe"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
    } catch (e) {
      // Ignore errors
    }
  }

  Future<void> downloadEpisode(Map<String, dynamic> episode) async {
    try {
      final body = {"episode": episode};
      await http.post(
        Uri.parse("$baseUrl/library/download"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
    } catch (e) {
      // Ignore errors
    }
  }
}