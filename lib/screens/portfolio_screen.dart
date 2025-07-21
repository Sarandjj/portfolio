// lib/screens/portfolio_screen.dart
import 'package:flutter/material.dart';
import 'package:portfolio/sections/footer_section.dart';
import 'package:portfolio/services/analytics_service.dart';
import 'package:portfolio/utils/loading_screen.dart';
import 'package:portfolio/utils/scroll_reveal_widget.dart';
import '../widgets/theme_switcher.dart';
import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/tech_stack_section.dart';
import '../sections/projects_section.dart';
import '../sections/experience_section.dart';
import '../sections/contact_section.dart';
import '../utils/parallax_scroll_controller.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late ParallaxScrollController _parallaxController;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _parallaxController = ParallaxScrollController();

    // Track portfolio page view
    AnalyticsService.logPageView(
      pageName: 'Portfolio Home',
      pageClass: 'PortfolioScreen',
    );
  }

  @override
  void dispose() {
    _parallaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!_showContent) {
    //   return LoadingScreen(
    //     onLoadingComplete: () {
    //       setState(() {
    //         _showContent = true;
    //       });

    //       // Track when loading completes
    //       AnalyticsService.logEngagementEvent(
    //         eventName: 'portfolio_loaded',
    //         parameters: {'load_time': DateTime.now().millisecondsSinceEpoch},
    //       );
    //     },
    //   );
    // }

    return Scaffold(
      body: Stack(
        children: [
          // Animated background with parallax - FIXED
          AnimatedBuilder(
            animation: _parallaxController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _parallaxController.getParallaxOffset(-0.5)),
                child: Container(
                  height: MediaQuery.of(context).size.height * 1.2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [
                              const Color(0xFF0A0E27), // Deep navy
                              const Color(0xFF16213E), // Dark blue
                              const Color(0xFF1A535C), // Teal
                              const Color(0xFF264653), // Deep green
                            ]
                          : [
                              const Color(0xFFE8F5E8), // Light green
                              const Color(0xFFE3F2FD), // Light blue
                              const Color(0xFFF0F8FF), // Alice blue
                              const Color(0xFFE0F2F1), // Light teal
                            ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // Floating particles
          FloatingParticles(
            particleCount: 25,
            particleColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF4ECDC4)
                : const Color(0xFF2E8B57),
            speed: 0.5,
          ),

          // Fixed floating orbs - No more Positioned inside Transform
          AnimatedBuilder(
            animation: _parallaxController,
            builder: (context, child) {
              return Stack(
                children: List.generate(3, (index) {
                  // Calculate positions with parallax
                  final baseTop = 100.0 + (index * 200);
                  final baseLeft = 50.0 + (index * 150);
                  final parallaxX = _parallaxController.getParallaxOffset(
                    0.2 + index * 0.1,
                  );
                  final parallaxY = _parallaxController.getParallaxOffset(
                    0.15 + index * 0.05,
                  );

                  return Positioned(
                    top: baseTop + parallaxY,
                    left: baseLeft + parallaxX,
                    child: Transform.rotate(
                      angle: _parallaxController.getRotationOffset(index + 1),
                      child: Transform.scale(
                        scale: _parallaxController.getScaleOffset(0.1),
                        child: Container(
                          width: 100 + (index * 50),
                          height: 100 + (index * 50),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                Theme.of(context).colorScheme.secondary.withOpacity(0.08),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // Main scrollable content
          SingleChildScrollView(
            controller: _parallaxController.scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const HeroSection(),

                ScrollRevealWidget(
                  startOffset: const Offset(0, 80),
                  child: const AboutSection(),
                ),

                ScrollRevealWidget(
                  startOffset: const Offset(-50, 50),
                  child: const TechStackSection(),
                ),

                // ScrollRevealWidget(
                //   startOffset: const Offset(50, 50),
                //   child: const ProjectsSection(),
                // ),
                ScrollRevealWidget(
                  startOffset: const Offset(0, 80),
                  child: const ExperienceSection(),
                ),

                ScrollRevealWidget(
                  startOffset: const Offset(0, 50),
                  child: const ContactSection(),
                ),

                const FooterSection(),
              ],
            ),
          ),

          // Floating theme switcher
          // Positioned(
          //   top: MediaQuery.of(context).size.width < 768 ? 20 : 40,
          //   right: MediaQuery.of(context).size.width < 768 ? 20 : 40,
          //   child: const ThemeSwitcher(),
          // ),
        ],
      ),
    );
  }
}
