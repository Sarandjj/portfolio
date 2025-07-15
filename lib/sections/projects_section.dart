import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../utils/scroll_animations.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late List<Animation<Offset>> _projectAnimations;

  final List<Project> _projects = [
    Project(
      'E-Commerce Flutter App',
      'A full-featured e-commerce application with payment integration, user authentication, and real-time notifications.',
      ['Flutter', 'Firebase', 'Stripe'],
      'https://github.com/example/ecommerce-app',
      'https://example-ecommerce.web.app',
    ),
    Project(
      'Social Media Dashboard',
      'Analytics dashboard for social media management with real-time data visualization and reporting features.',
      ['Flutter', 'Node.js', 'MongoDB'],
      'https://github.com/example/social-dashboard',
      'https://social-dashboard.web.app',
    ),
    Project(
      'Weather Forecast App',
      'Beautiful weather application with location-based forecasts, interactive maps, and weather alerts.',
      ['Flutter', 'OpenWeather API', 'Maps'],
      'https://github.com/example/weather-app',
      'https://weather-app.web.app',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _projectAnimations = List.generate(
      _projects.length,
      (index) => Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: Interval(index * 0.2, (index * 0.2) + 0.4, curve: Curves.easeOut),
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isMobile = size.width < 768;

    return ScrollRevealWidget(
      startOffset: const Offset(0, 100),
      duration: const Duration(milliseconds: 1200),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
          vertical: isMobile ? 40 : (isTablet ? 60 : 80),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? size.width - 40 : (isTablet ? 800 : 1200),
            ),
            child: Column(
              children: [
                ScrollRevealWidget(
                  startOffset: const Offset(0, 40),
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'Featured Projects',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 20),
                ScrollRevealWidget(
                  startOffset: const Offset(0, 30),
                  duration: const Duration(milliseconds: 900),
                  child: Text(
                    'Here are some of the projects I\'ve worked on recently',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: isMobile ? 14 : 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isMobile ? 40 : 60),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 2),
                    crossAxisSpacing: isMobile ? 20 : 30,
                    mainAxisSpacing: isMobile ? 20 : 30,
                    childAspectRatio: isMobile ? 1.2 : (isTablet ? 0.9 : 0.8),
                  ),
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    return SlideTransition(
                      position: _projectAnimations[index],
                      child: FadeTransition(
                        opacity: _slideController,
                        child: _buildProjectCard(_projects[index], isMobile, isTablet),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project project, bool isMobile, bool isTablet) {
    return ShadowAnimationWidget(
      maxShadowIntensity: 0.3,
      shadowColor: Theme.of(context).colorScheme.primary,
      blurRadius: 30.0,
      shadowOffset: const Offset(0, 20),
      child: GlassContainer(
        padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 20 : 24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project thumbnail placeholder
            Container(
              height: isMobile ? 100 : (isTablet ? 110 : 120),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                  ],
                ),
              ),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.7 + (0.3 * value),
                    child: Icon(
                      Icons.code,
                      size: isMobile ? 36 : (isTablet ? 42 : 48),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
              ),
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              project.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: isMobile ? 12 : 14),
              maxLines: isMobile ? 2 : 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Wrap(
              spacing: isMobile ? 6 : 8,
              runSpacing: isMobile ? 6 : 8,
              children: project.technologies
                  .map(
                    (tech) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 6 : 8,
                        vertical: isMobile ? 3 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        tech,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: isMobile ? 10 : 12,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildProjectButton('GitHub', Icons.code, () {
                        // Open GitHub link
                      }, isMobile),
                    ),
                    SizedBox(width: isMobile ? 8 : 12),
                    Expanded(
                      child: _buildProjectButton('Live Demo', Icons.launch, () {
                        // Open live demo
                      }, isMobile),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectButton(
    String text,
    IconData icon,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return GlassContainer(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 6 : 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isMobile ? 14 : 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: isMobile ? 3 : 4),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 11 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String githubUrl;
  final String demoUrl;

  Project(this.title, this.description, this.technologies, this.githubUrl, this.demoUrl);
}
