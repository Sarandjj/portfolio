import 'package:flutter/material.dart';
import '../widgets/theme_switcher.dart';
import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/tech_stack_section.dart';
import '../sections/projects_section.dart';
import '../sections/experience_section.dart';
import '../sections/contact_section.dart';
import '../sections/footer_section.dart';
import '../utils/scroll_controller.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late SmoothScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = SmoothScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        const Color(0xFF0F0F23),
                        const Color(0xFF1E1E2E),
                        const Color(0xFF262640),
                        const Color(0xFF1A1A2E),
                      ]
                    : [
                        const Color(0xFFF8FAFC),
                        const Color(0xFFE2E8F0),
                        const Color(0xFFF1F5F9),
                        const Color(0xFFEDE9FE),
                      ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          // Floating orbs for visual enhancement
          ...List.generate(
            3,
            (index) => Positioned(
              top: 100.0 + (index * 200),
              left: 50.0 + (index * 150),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 2000 + (index * 500)),
                curve: Curves.easeInOut,
                child: Container(
                  width: 100 + (index * 50),
                  height: 100 + (index * 50),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            controller: _scrollController.scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const HeroSection(),
                // TweenAnimationBuilder<double>(
                //   duration: const Duration(milliseconds: 800),
                //   tween: Tween(begin: 0.0, end: 1.0),
                //   builder: (context, value, child) {
                //     return Transform.translate(
                //       offset: Offset(0, 30 * (1 - value)),
                //       child: Opacity(opacity: value, child: const AboutSection()),
                //     );
                //   },
                // ),
                // TweenAnimationBuilder<double>(
                //   duration: const Duration(milliseconds: 1000),
                //   tween: Tween(begin: 0.0, end: 1.0),
                //   builder: (context, value, child) {
                //     return Transform.translate(
                //       offset: Offset(0, 30 * (1 - value)),
                //       child: Opacity(opacity: value, child: const TechStackSection()),
                //     );
                //   },
                // ),
                // TweenAnimationBuilder<double>(
                //   duration: const Duration(milliseconds: 1200),
                //   tween: Tween(begin: 0.0, end: 1.0),
                //   builder: (context, value, child) {
                //     return Transform.translate(
                //       offset: Offset(0, 30 * (1 - value)),
                //       child: Opacity(opacity: value, child: const ProjectsSection()),
                //     );
                //   },
                // ),
                // TweenAnimationBuilder<double>(
                //   duration: const Duration(milliseconds: 1400),
                //   tween: Tween(begin: 0.0, end: 1.0),
                //   builder: (context, value, child) {
                //     return Transform.translate(
                //       offset: Offset(0, 30 * (1 - value)),
                //       child: Opacity(opacity: value, child: const ExperienceSection()),
                //     );
                //   },
                // ),
                // TweenAnimationBuilder<double>(
                //   duration: const Duration(milliseconds: 1600),
                //   tween: Tween(begin: 0.0, end: 1.0),
                //   builder: (context, value, child) {
                //     return Transform.translate(
                //       offset: Offset(0, 30 * (1 - value)),
                //       child: Opacity(opacity: value, child: const ContactSection()),
                //     );
                //   },
                // ),
                const FooterSection(),
              ],
            ),
          ),
          // Floating theme switcher
          Positioned(
            top: MediaQuery.of(context).size.width < 768 ? 20 : 40,
            right: MediaQuery.of(context).size.width < 768 ? 20 : 40,
            child: const ThemeSwitcher(),
          ),
        ],
      ),
    );
  }
}
