import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../models/podcast_model.dart';
import '../player/player_screen.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'search_controller.dart' as svc;

class SearchScreen extends StatefulWidget {
  final bool autoFocus;
  const SearchScreen({
    super.key,
    this.autoFocus = false,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = svc.SearchController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  svc.FilterAttributes _filters = const svc.FilterAttributes();

  @override
  void initState() {
    super.initState();
    if (widget.autoFocus) {
      _focusNode.requestFocus();
    }
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => controller.isLoading = true);
    await controller.loadInitial();
    if (mounted) setState(() => controller.isLoading = false);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    setState(() => controller.isLoading = true);
    await controller.search(query, filters: _filters);
    if (mounted) setState(() => controller.isLoading = false);
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const FilterBottomSheet();
      },
    );

    if (result != null) {
      _filters = svc.FilterAttributes(
        categories: List<String>.from(result['categories'] ?? []),
        maxDuration: result['maxDuration'] ?? 120,
        minRating: result['minRating'] ?? 0,
      );
      setState(() => controller.isLoading = true);
      await controller.search(_textController.text, filters: _filters);
      if (mounted) setState(() => controller.isLoading = false);
    }
  }

  void _onPodcastTap(Podcast podcast) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerScreen(podcast: podcast),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Back Button
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Search TextField
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              focusNode: _focusNode,
                              autofocus: widget.autoFocus,
                              style: const TextStyle(color: Colors.white),
                              onChanged: _onSearchChanged,
                              decoration: const InputDecoration(
                                hintText: "Search podcasts...",
                                hintStyle: TextStyle(color: AppColors.textSecondary),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _openFilterSheet,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _filters.isEmpty ? AppColors.border : AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: _filters.isEmpty ? AppColors.textSecondary : AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Results Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: controller.currentQuery.isEmpty
                          ? "Top podcasts"
                          : "${controller.searchResults.length} results",
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                    if (controller.currentQuery.isNotEmpty)
                      TextSpan(
                        text: " for \"${controller.currentQuery}\"",
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // List of Podcasts
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : controller.searchResults.isEmpty && controller.currentQuery.isNotEmpty
                      ? const Center(
                          child: Text(
                            "No podcasts found",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final pod = controller.searchResults[index];

                  // Determine icon proxy color based on category
                  Color iconColor = AppColors.primary;
                  if (pod.category == "Business") {
                    iconColor = Colors.orange;
                  } else if (pod.category == "Comedy") {
                    iconColor = Colors.purpleAccent;
                  } else if (pod.category == "Technology") {
                    iconColor = Colors.blue;
                  } else if (pod.category == "News") {
                    iconColor = Colors.red;
                  } else if (pod.category == "Health") {
                    iconColor = Colors.green;
                  }

                  return GestureDetector(
                    onTap: () => _onPodcastTap(pod),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Podcast Image / Icon replacement
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: iconColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.album,
                                color: iconColor,
                                size: 32,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Text info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pod.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  pod.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Small Tag
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: iconColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    pod.category,
                                    style: TextStyle(
                                      color: iconColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Duration Text
                          Text(
                            pod.duration,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
