// lib/sections/about_section.dart
import 'package:flutter/material.dart';
import 'package:portfolio/utils/scroll_reveal_widget.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 60 : 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? size.width - 40 : 1000),
          child: ScrollRevealWidget(
            startOffset: const Offset(0, 60),
            child: MouseRegion(
              onEnter: (_) => _hoverController.forward(),
              onExit: (_) => _hoverController.reverse(),
              child: AnimatedBuilder(
                animation: _hoverAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _hoverAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  const Color(0xFF1E293B).withOpacity(0.7),
                                  const Color(0xFF334155).withOpacity(0.5),
                                  const Color(0xFF1E293B).withOpacity(0.8),
                                ]
                              : [
                                  const Color(0xFFFFFFFF).withOpacity(0.9),
                                  const Color(0xFFF8FAFC).withOpacity(0.8),
                                  const Color(0xFFFFFFFF).withOpacity(0.95),
                                ],
                        ),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF34D399).withOpacity(0.2)
                              : const Color(0xFF059669).withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? const Color(0xFF000000).withOpacity(0.3)
                                : const Color(0xFF000000).withOpacity(0.1),
                            blurRadius: 30,
                            spreadRadius: 0,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: isDark
                                ? const Color(0xFF34D399).withOpacity(0.1)
                                : const Color(0xFF059669).withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: -5,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: EdgeInsets.all(isMobile ? 30 : 50),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      Colors.white.withOpacity(0.05),
                                      Colors.white.withOpacity(0.02),
                                    ]
                                  : [
                                      Colors.white.withOpacity(0.6),
                                      Colors.white.withOpacity(0.3),
                                    ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Section
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).colorScheme.primary,
                                            Theme.of(context).colorScheme.secondary,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary.withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '👨‍💻 About Me',
                                        style: TextStyle(
                                          fontSize: isMobile ? 16 : 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: isMobile ? 20 : 30),
                                    ShaderMask(
                                      shaderCallback: (bounds) => LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context).colorScheme.secondary,
                                        ],
                                      ).createShader(bounds),
                                      child: Text(
                                        'Passionate Flutter Developer',
                                        style: Theme.of(context).textTheme.displayMedium
                                            ?.copyWith(
                                              fontSize: isMobile ? 28 : 36,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: isMobile ? 30 : 40),

                              // Content Grid
                              isMobile
                                  ? Column(
                                      children: _buildContentSections(context, isMobile),
                                    )
                                  : Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: _buildContentSections(
                                            context,
                                            isMobile,
                                          )[0],
                                        ),
                                        const SizedBox(width: 40),
                                        Expanded(
                                          flex: 1,
                                          child: _buildContentSections(
                                            context,
                                            isMobile,
                                          )[1],
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContentSections(BuildContext context, bool isMobile) {
    return [
      // Story Section
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🚀 My Journey',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'I am a dedicated Flutter developer with a passion for creating beautiful, high-performance mobile and web applications. My journey in software development began with curiosity about how digital experiences come to life.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: isMobile ? 14 : 16,
                    height: 1.7,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF4A5568),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Today, I specialize in Flutter development, building cross-platform applications that deliver exceptional user experiences across all devices. I believe in writing clean, efficient code that not only works but also tells a story.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: isMobile ? 14 : 16,
                    height: 1.7,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF4A5568),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      if (isMobile) SizedBox(height: isMobile ? 30 : 0),

      // Skills Section
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 What I Bring',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          _buildSkillsList(context, isMobile),

          const SizedBox(height: 30),

          // Stats Row
          _buildStatsRow(context, isMobile),
        ],
      ),
    ];
  }

  Widget _buildSkillsList(BuildContext context, bool isMobile) {
    final skills = [
      {'icon': '📱', 'title': 'Cross-platform Development', 'desc': 'iOS & Android'},
      {'icon': '🎨', 'title': 'UI/UX Implementation', 'desc': 'Beautiful interfaces'},
      {'icon': '⚡', 'title': 'Performance Optimization', 'desc': 'Smooth & fast'},
      {'icon': '🔗', 'title': 'Backend Integration', 'desc': 'APIs & databases'},
    ];

    return Column(
      children: skills
          .map(
            (skill) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                    Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(skill['icon']!, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill['title']!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 14 : 16,
                          ),
                        ),
                        Text(
                          skill['desc']!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: isMobile ? 12 : 14,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isMobile) {
    final stats = [
      {'number': '3+', 'label': 'Years Experience'},
      {'number': '50+', 'label': 'Projects Done'},
      {'number': '100%', 'label': 'Client Satisfaction'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      ),
      child: isMobile
          ? Column(
              children: stats
                  .map((stat) => _buildStatItem(context, stat, isMobile))
                  .toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: stats
                  .map((stat) => _buildStatItem(context, stat, isMobile))
                  .toList(),
            ),
    );
  }

  Widget _buildStatItem(BuildContext context, Map<String, String> stat, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 0),
      child: Column(
        children: [
          Text(
            stat['number']!,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            stat['label']!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
