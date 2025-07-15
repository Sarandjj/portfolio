import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../utils/scroll_animations.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (!_isVisible) {
      setState(() {
        _isVisible = true;
      });
      _slideController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isMobile = size.width < 768;

    return ScrollRevealWidget(
      startOffset: const Offset(0, 80),
      duration: const Duration(milliseconds: 1000),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
          vertical: isMobile ? 40 : (isTablet ? 60 : 80),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Trigger animation when section becomes visible
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkVisibility();
            });

            return SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _slideController,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isMobile ? size.width - 40 : (isTablet ? 600 : 800),
                    ),
                    child: ShadowAnimationWidget(
                      maxShadowIntensity: 0.2,
                      shadowColor: Theme.of(context).colorScheme.primary,
                      blurRadius: 25.0,
                      shadowOffset: const Offset(0, 15),
                      child: GlassContainer(
                        padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 30 : 40)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'About Me',
                                style: Theme.of(context).textTheme.displayMedium
                                    ?.copyWith(
                                      fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                                    ),
                              ),
                            ),
                            SizedBox(height: isMobile ? 30 : 40),
                            Text(
                              'Passionate Flutter Developer',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: isMobile ? 20 : (isTablet ? 22 : 24),
                              ),
                            ),
                            SizedBox(height: isMobile ? 16 : 20),
                            Text(
                              'I am a dedicated Flutter developer with a passion for creating beautiful, high-performance mobile and web applications. With expertise in modern development practices and a keen eye for user experience, I transform ideas into reality through clean, efficient code.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: isMobile ? 14 : 16,
                              ),
                            ),
                            SizedBox(height: isMobile ? 16 : 20),
                            Text(
                              'My journey in software development began with a curiosity for how things work behind the scenes. Today, I specialize in Flutter development, building cross-platform applications that deliver exceptional user experiences across all devices.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: isMobile ? 14 : 16,
                              ),
                            ),
                            SizedBox(height: isMobile ? 24 : 30),
                            _buildSkillHighlights(context, isMobile),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkillHighlights(BuildContext context, bool isMobile) {
    final highlights = [
      'Cross-platform Development',
      'UI/UX Design Implementation',
      'Backend Integration',
      'Performance Optimization',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What I bring to the table:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? 14 : 16,
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        ...highlights
            .map(
              (highlight) => Padding(
                padding: EdgeInsets.symmetric(vertical: isMobile ? 3 : 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: isMobile ? 18 : 20,
                    ),
                    SizedBox(width: isMobile ? 10 : 12),
                    Expanded(
                      child: Text(
                        highlight,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontSize: isMobile ? 14 : 16),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
