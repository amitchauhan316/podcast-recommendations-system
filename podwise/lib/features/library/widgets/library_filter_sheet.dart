import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class LibraryFilterSheet extends StatefulWidget {
  final Set<String> initialStatuses;
  final Set<String> initialShows;
  final double initialDuration;
  final String initialSort;
  final List<String> availableShows;
  final Function(Set<String>, Set<String>, double, String) onApplyFilters;

  const LibraryFilterSheet({
    super.key,
    required this.initialStatuses,
    required this.initialShows,
    required this.initialDuration,
    required this.initialSort,
    required this.availableShows,
    required this.onApplyFilters,
  });

  @override
  State<LibraryFilterSheet> createState() => _LibraryFilterSheetState();
}

class _LibraryFilterSheetState extends State<LibraryFilterSheet> {
  late Set<String> selectedStatuses;
  late Set<String> selectedShows;
  late double duration;
  late String selectedSort;

  @override
  void initState() {
    super.initState();
    selectedStatuses = Set.from(widget.initialStatuses);
    selectedShows = Set.from(widget.initialShows);
    duration = widget.initialDuration;
    selectedSort = widget.initialSort;
  }

  void _resetAll() {
    setState(() {
      selectedStatuses = {'All'};
      selectedShows.clear();
      duration = 120.0;
      selectedSort = 'Newest';
    });
  }

  Widget _buildStatusChip(String label, Color activeColor) {
    final isSelected = selectedStatuses.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'All') {
            selectedStatuses.clear();
            selectedStatuses.add('All');
          } else {
            selectedStatuses.remove('All');
            if (isSelected) {
              selectedStatuses.remove(label);
            } else {
              selectedStatuses.add(label);
            }
            if (selectedStatuses.isEmpty) {
              selectedStatuses.add('All');
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected ? activeColor : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? activeColor : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildGenericChip(
    String label,
    bool isSelected,
    Color activeColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected ? activeColor : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? activeColor : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

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
                "Library Filter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: _resetAll,
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

          // STATUS section
          const Text(
            "STATUS",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildStatusChip("All", AppColors.primary),
              _buildStatusChip("In Progress", AppColors.primary),
              _buildStatusChip("New", AppColors.secondary),
              _buildStatusChip("Done", AppColors.primary),
              _buildStatusChip("Saved", AppColors.primary),
            ],
          ),
          const SizedBox(height: 32),

          // SHOW section
          const Text(
            "SHOW",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.availableShows.map((show) {
              final isSelected = selectedShows.contains(show);
              return _buildGenericChip(
                show,
                isSelected,
                AppColors.primary,
                () {
                  setState(() {
                    if (isSelected) {
                      selectedShows.remove(show);
                    } else {
                      selectedShows.add(show);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // DURATION section
          const Text(
            "DURATION",
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
              const Text("Up to", style: TextStyle(color: AppColors.textSecondary)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.border,
                    thumbColor: AppColors.primary,
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: duration,
                    min: 10,
                    max: 120,
                    onChanged: (val) {
                      setState(() {
                        duration = val;
                      });
                    },
                  ),
                ),
              ),
              Text(
                "${duration.toInt()} min",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // SORT BY section
          const Text(
            "SORT BY",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ["Newest", "Oldest", "A - Z", "Duration"].map((sort) {
              final isSelected = selectedSort == sort;
              return _buildGenericChip(
                sort,
                isSelected,
                AppColors.secondary,
                () {
                  setState(() {
                    selectedSort = sort;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 48),

          // Apply Button
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
                widget.onApplyFilters(selectedStatuses, selectedShows, duration, selectedSort);
                Navigator.pop(context);
              },
              child: const Text(
                "Apply",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
