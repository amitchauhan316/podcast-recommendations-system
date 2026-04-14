import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F171A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Top Logo Fade In
              _FadeSlideWidget(
                controller: _entranceController,
                interval: const Interval(0.0, 0.4, curve: Curves.easeOut),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.bar_chart, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Podwise",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Animated Headphone Graphic
              _FadeSlideWidget(
                controller: _entranceController,
                interval: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: child,
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.15),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.headphones,
                          color: AppColors.primary,
                          size: 80,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Welcome Text
              _FadeSlideWidget(
                controller: _entranceController,
                interval: const Interval(0.4, 0.8, curve: Curves.easeOut),
                child: const Column(
                  children: [
                     Center(
                      child: Text(
                        "Welcome to Podwise",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        "Your AI-powered podcast\ncompanion. Discover shows\nmade just for you.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Features List
              _FadeSlideWidget(
                controller: _entranceController,
                interval: const Interval(0.5, 0.9, curve: Curves.easeOut),
                child: _buildFeatureRow(
                  icon: Icons.check,
                  color: AppColors.primary,
                  title: "Smart Recommendations",
                  subtitle: "AI tara interest ane history thi suggest kare",
                ),
              ),
              const SizedBox(height: 24),
              _FadeSlideWidget(
                controller: _entranceController,
                interval: const Interval(0.6, 1.0, curve: Curves.easeOut),
                child: _buildFeatureRow(
                  icon: Icons.arrow_upward,
                  color: const Color(0xFF2D9CDB),
                  title: "Offline Downloads",
                  subtitle: "Internet vagar pan suno",
                ),
              ),
              const SizedBox(height: 24),
              _FadeSlideWidget(
                controller: _entranceController,
                interval: const Interval(0.7, 1.0, curve: Curves.easeOut),
                child: _buildFeatureRow(
                  icon: Icons.access_time_filled,
                  color: const Color(0xFFA67CFF),
                  title: "Smart Player",
                  subtitle: "Speed control, sleep timer, accessibility",
                ),
              ),
              
              const Spacer(),
              
              // Get Started Button
              _FadeSlideWidget(
                controller: _entranceController,
                interval: const Interval(0.8, 1.0, curve: Curves.easeOut),
                child: SizedBox(
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
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a1, a2) => const OnboardingScreen(),
                          transitionsBuilder: (context, a1, a2, child) {
                            return FadeTransition(opacity: a1, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 600),
                        ),
                      );
                    },
                    child: const Text(
                      "Get Started →",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FadeSlideWidget extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Widget child;

  const _FadeSlideWidget({
    required this.controller,
    required this.interval,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: interval));
    final slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: controller, curve: interval));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
