import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../services/user_state.dart';

class OnboardingController {
  // 🧠 Available categories
  final List<Category> categories = [
    Category(id: "health", name: "Health", iconData: Icons.favorite, iconColor: const Color(0xFF4CD964)),
    Category(id: "crime", name: "True Crime", iconData: Icons.access_time, iconColor: const Color(0xFFFF3B30)),
    Category(id: "news", name: "News", iconData: Icons.chat_bubble, iconColor: const Color(0xFFFF9500)),
    Category(id: "comedy", name: "Comedy", iconData: Icons.person, iconColor: const Color(0xFFA67CFF)),
    Category(id: "business", name: "Business", iconData: Icons.bar_chart, iconColor: const Color(0xFF4CD964)),
    Category(id: "lifestyle", name: "Lifestyle", iconData: Icons.self_improvement, iconColor: const Color(0xFF5AC8FA)),
    Category(id: "tech", name: "Technology", iconData: Icons.smart_toy, iconColor: const Color(0xFF00C2A8)),
    Category(id: "music", name: "Music", iconData: Icons.music_note, iconColor: const Color(0xFFA67CFF)),
    Category(id: "sports", name: "Sports", iconData: Icons.sports_basketball, iconColor: const Color(0xFFFF9500)),
    Category(id: "education", name: "Education", iconData: Icons.school, iconColor: const Color(0xFF5AC8FA)),
  ];

  // 📌 Selected interests
  final List<Category> selectedInterests = [];

  // 🔁 Toggle selection
  void toggleInterest(Category category) {
    if (selectedInterests.contains(category)) {
      selectedInterests.remove(category);
    } else {
      selectedInterests.add(category);
    }
  }

  // ✅ Check if selected
  bool isSelected(Category category) {
    return selectedInterests.contains(category);
  }

  // Save to global state
  void saveSelections() {
    UserState().selectedCategories = selectedInterests.map((e) => e.name).toList();
  }
}