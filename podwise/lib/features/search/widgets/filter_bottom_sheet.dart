import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/category_model.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<Category> filterCategories = [
    Category(id: "Technology", name: "Technology", iconColor: const Color(0xFF00C2A8)),
    Category(id: "Business", name: "Business", iconColor: const Color(0xFF4CD964)),
    Category(id: "News", name: "News", iconColor: const Color(0xFFFF9500)),
    Category(id: "Comedy", name: "Comedy", iconColor: const Color(0xFFA67CFF)),
    Category(id: "True Crime", name: "True Crime", iconColor: const Color(0xFFFF3B30)),
  ];

  List<String> selectedCategories = [];
  double episodeLength = 60.0;
  int minRating = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter & Sort",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategories.clear();
                    episodeLength = 60.0;
                    minRating = 0;
                  });
                },
                child: const Text(
                  "Reset all",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Category Label
          const Text(
            "CATEGORY",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // Category Chips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: filterCategories.map((cat) {
              final isSelected = selectedCategories.contains(cat.name);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedCategories.remove(cat.name);
                    } else {
                      selectedCategories.add(cat.name);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    cat.name,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Episode Length Label
          const Text(
            "EPISODE LENGTH",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                "Up to",
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.border,
                    thumbColor: AppColors.primary,
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: episodeLength,
                    min: 10,
                    max: 120,
                    onChanged: (val) {
                      setState(() {
                        episodeLength = val;
                      });
                    },
                  ),
                ),
              ),
              Text(
                "${episodeLength.toInt()} min",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Min Rating Label
          const Text(
            "MIN RATING",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                "Stars",
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(width: 16),
              ...List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      minRating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.star,
                      color: index < minRating ? Colors.orange : AppColors.border,
                      size: 28,
                    ),
                  ),
                );
              }),
              const SizedBox(width: 16),
              const Text(
                "& above",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Bottom Buttons
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'categories': selectedCategories,
                  'maxDuration': episodeLength.toInt(),
                  'minRating': minRating,
                });
              },
              child: const Text(
                "Apply Filters",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedCategories.clear();
                  episodeLength = 60.0;
                  minRating = 0;
                });
              },
              child: const Text(
                "Clear All",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
