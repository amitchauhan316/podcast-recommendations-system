import 'package:flutter/material.dart';
import '../../models/podcast_model.dart';
import '../../services/api_service.dart';

class LibraryEpisode {
  final String id;
  final String title;
  final String author;
  final Color iconColor;
  final String statusTag; // "NEW", "DONE", or ""
  final String timeLeft;
  final double progress; // 0.0 to 1.0
  final String category; // "subscribed", "saved", "downloaded"

  LibraryEpisode({
    required this.id,
    required this.title,
    required this.author,
    required this.iconColor,
    this.statusTag = "",
    this.timeLeft = "",
    this.progress = 0.0,
    required this.category,
  });
}

class LibraryController {
  final ApiService _apiService = ApiService();

  int subscribedCount = 0;
  int savedCount = 0;
  int downloadedCount = 0;
  
  final List<String> filterTabs = ["All Episodes", "Subscribed", "Saved", "Downloads"];
  String selectedFilter = "All Episodes";

  final List<Color> subscribedFlows = [
    const Color(0xFF00C2A8),
    const Color(0xFFA67CFF),
    const Color(0xFFFF3B30),
    const Color(0xFFFF9500),
  ];

  List<LibraryEpisode> allEpisodes = [];
  List<LibraryEpisode> subscribedEpisodes = [];
  List<LibraryEpisode> savedEpisodes = [];
  List<LibraryEpisode> downloadedEpisodes = [];
  List<LibraryEpisode> recentEpisodes = [];

  // Filter states
  Set<String> selectedStatuses = {'All'};
  Set<String> selectedShows = {};
  double maxDuration = 120.0;
  String selectedSort = 'Newest';

  int get filteredCount => recentEpisodes.length;
  List<String> get availableShows => allEpisodes.map((e) => e.author).toSet().toList();

  Future<void> loadLibraryData() async {
    try {
      final subscribedData = await _apiService.fetchSubscribedEpisodes();
      final savedData = await _apiService.fetchSavedEpisodes();
      final downloadedData = await _apiService.fetchDownloadedEpisodes();

      subscribedEpisodes = subscribedData.map((data) => LibraryEpisode(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        author: data['author'] ?? '',
        iconColor: _getColorFromCategory(data['category'] ?? 'Other'),
        statusTag: data['statusTag'] ?? '',
        timeLeft: data['timeLeft'] ?? '',
        progress: (data['progress'] ?? 0.0).toDouble(),
        category: 'subscribed',
      )).toList();

      savedEpisodes = savedData.map((data) => LibraryEpisode(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        author: data['author'] ?? '',
        iconColor: _getColorFromCategory(data['category'] ?? 'Other'),
        statusTag: data['statusTag'] ?? '',
        timeLeft: data['timeLeft'] ?? '',
        progress: (data['progress'] ?? 0.0).toDouble(),
        category: 'saved',
      )).toList();

      downloadedEpisodes = downloadedData.map((data) => LibraryEpisode(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        author: data['author'] ?? '',
        iconColor: _getColorFromCategory(data['category'] ?? 'Other'),
        statusTag: data['statusTag'] ?? '',
        timeLeft: data['timeLeft'] ?? '',
        progress: (data['progress'] ?? 0.0).toDouble(),
        category: 'downloaded',
      )).toList();

      // Combine all episodes
      allEpisodes = [...subscribedEpisodes, ...savedEpisodes, ...downloadedEpisodes];

      // Update counts
      subscribedCount = subscribedEpisodes.length;
      savedCount = savedEpisodes.length;
      downloadedCount = downloadedEpisodes.length;

      // Initially show all episodes
      recentEpisodes = List.from(allEpisodes);
      _applyFilters();
    } catch (e) {
      // Fallback to static data if API fails
      _loadStaticData();
    }
  }

  void _loadStaticData() {
    // Static data for subscribed episodes
    subscribedEpisodes = [
      LibraryEpisode(
        id: 'sub1',
        title: 'The Future of AI',
        author: 'Lex Fridman',
        iconColor: const Color(0xFF00C2A8),
        statusTag: 'NEW',
        timeLeft: '1h 12m left',
        progress: 0.3,
        category: 'subscribed',
      ),
      LibraryEpisode(
        id: 'sub2',
        title: 'Building Startups',
        author: 'Y Combinator',
        iconColor: const Color(0xFFA67CFF),
        statusTag: '',
        timeLeft: '48m left',
        progress: 0.0,
        category: 'subscribed',
      ),
      LibraryEpisode(
        id: 'sub3',
        title: 'Tech News Weekly',
        author: 'TechCrunch',
        iconColor: const Color(0xFFFF9500),
        statusTag: 'DONE',
        timeLeft: '',
        progress: 1.0,
        category: 'subscribed',
      ),
    ];

    // Static data for saved episodes
    savedEpisodes = [
      LibraryEpisode(
        id: 'sav1',
        title: 'Mindfulness Meditation',
        author: 'Calm',
        iconColor: const Color(0xFF00C2A8),
        statusTag: '',
        timeLeft: '22m left',
        progress: 0.7,
        category: 'saved',
      ),
      LibraryEpisode(
        id: 'sav2',
        title: 'Cooking Tips',
        author: 'Gordon Ramsay',
        iconColor: const Color(0xFFFF3B30),
        statusTag: 'NEW',
        timeLeft: '',
        progress: 0.0,
        category: 'saved',
      ),
    ];

    // Static data for downloaded episodes
    downloadedEpisodes = [
      LibraryEpisode(
        id: 'down1',
        title: 'History of Rome',
        author: 'BBC History',
        iconColor: const Color(0xFFA67CFF),
        statusTag: 'DONE',
        timeLeft: '',
        progress: 1.0,
        category: 'downloaded',
      ),
      LibraryEpisode(
        id: 'down2',
        title: 'Jazz Classics',
        author: 'Blue Note',
        iconColor: const Color(0xFFFF9500),
        statusTag: '',
        timeLeft: '30m left',
        progress: 0.5,
        category: 'downloaded',
      ),
    ];

    // Combine all episodes
    allEpisodes = [...subscribedEpisodes, ...savedEpisodes, ...downloadedEpisodes];

    // Update counts
    subscribedCount = subscribedEpisodes.length;
    savedCount = savedEpisodes.length;
    downloadedCount = downloadedEpisodes.length;

    // Initially show all episodes
    recentEpisodes = List.from(allEpisodes);
    _applyFilters();
  }

  Color _getColorFromCategory(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
      case 'ai':
        return const Color(0xFF00C2A8);
      case 'business':
        return const Color(0xFFFF9500);
      case 'comedy':
        return const Color(0xFFA67CFF);
      case 'true crime':
        return const Color(0xFFFF3B30);
      default:
        return const Color(0xFF00C2A8);
    }
  }

  void selectFilter(String filter) {
    selectedFilter = filter;
    switch (filter) {
      case "All Episodes":
        recentEpisodes = List.from(allEpisodes);
        break;
      case "Subscribed":
        recentEpisodes = List.from(subscribedEpisodes);
        break;
      case "Saved":
        recentEpisodes = List.from(savedEpisodes);
        break;
      case "Downloads":
        recentEpisodes = List.from(downloadedEpisodes);
        break;
    }
    _applyFilters();
  }

  void updateFilters(Set<String> statuses, Set<String> shows, double duration, String sort) {
    selectedStatuses = statuses;
    selectedShows = shows;
    maxDuration = duration;
    selectedSort = sort;
    _applyFilters();
  }

  void _applyFilters() {
    List<LibraryEpisode> filtered = [];

    // Start with the current filter's episodes
    switch (selectedFilter) {
      case "All Episodes":
        filtered = List.from(allEpisodes);
        break;
      case "Subscribed":
        filtered = List.from(subscribedEpisodes);
        break;
      case "Saved":
        filtered = List.from(savedEpisodes);
        break;
      case "Downloads":
        filtered = List.from(downloadedEpisodes);
        break;
    }

    // Apply status filter
    if (!selectedStatuses.contains('All')) {
      filtered = filtered.where((ep) {
        if (selectedStatuses.contains('New') && ep.statusTag == 'NEW') return true;
        if (selectedStatuses.contains('Done') && ep.statusTag == 'DONE') return true;
        if (selectedStatuses.contains('In Progress') && ep.progress > 0 && ep.progress < 1) return true;
        if (selectedStatuses.contains('Saved') && ep.category == 'saved') return true;
        return false;
      }).toList();
    }

    // Apply show filter
    if (selectedShows.isNotEmpty) {
      filtered = filtered.where((ep) => selectedShows.contains(ep.author)).toList();
    }

    // Apply duration filter (assuming duration is in minutes, but we don't have duration data, so skip for now)

    // Apply sorting
    switch (selectedSort) {
      case 'Newest':
        // Assuming newer episodes have higher progress or something, for now keep as is
        break;
      case 'Oldest':
        filtered = filtered.reversed.toList();
        break;
      case 'A - Z':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Duration':
        // No duration data, skip
        break;
    }

    recentEpisodes = filtered;
  }
}

