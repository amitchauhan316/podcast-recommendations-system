import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../library/library_screen.dart';
import '../../core/constants/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main Content
          Positioned.fill(
            child: screens[currentIndex],
          ),

          // Custom Floating Bottom Navigation Bar
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: _buildCustomBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24), // Dark grey from image
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_outlined, 0),
          _buildNavItem(Icons.search, 1),
          _buildNavItem(Icons.bookmark_outline, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C2F48) : Colors.transparent, // Purple-ish background for active
          shape: BoxShape.circle,
        ),
        child: AnimatedTheme(
          data: ThemeData(
            iconTheme: IconThemeData(
              color: isSelected ? const Color(0xFF00E5FF) : AppColors.textSecondary,
              size: 28,
            ),
          ),
          child: Icon(icon),
        ),
      ),
    );
  }
}
