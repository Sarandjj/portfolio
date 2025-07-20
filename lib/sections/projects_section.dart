import 'package:flutter/material.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  final List<Project> _projects = const [
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isMobile = size.width < 768;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - value)),
          child: Opacity(
            opacity: value,
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
                      // Header
                      Text(
                        'Featured Projects',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      Text(
                        'Here are some of the projects I\'ve worked on recently',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontSize: isMobile ? 14 : 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 40 : 60),

                      // Projects Grid
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
                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 800 + (index * 200)),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, animValue, child) {
                              return Transform.translate(
                                offset: Offset(0, 50 * (1 - animValue)),
                                child: Opacity(
                                  opacity: animValue,
                                  child: _buildProjectCard(
                                    _projects[index],
                                    isMobile,
                                    isTablet,
                                    context,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(
    Project project,
    bool isMobile,
    bool isTablet,
    BuildContext context,
  ) {
    return Card(
      elevation: 12,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 20 : 24)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).cardColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project thumbnail
            Container(
              height: isMobile ? 100 : (isTablet ? 110 : 120),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                  ],
                ),
              ),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1000),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.7 + (0.3 * value),
                    child: Icon(
                      Icons.code_rounded,
                      size: isMobile ? 36 : (isTablet ? 42 : 48),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),

            // Title
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isMobile ? 8 : 12),

            // Description
            Text(
              project.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: isMobile ? 12 : 14, height: 1.4),
              maxLines: isMobile ? 2 : 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isMobile ? 12 : 16),

            // Technologies
            Wrap(
              spacing: isMobile ? 6 : 8,
              runSpacing: isMobile ? 6 : 8,
              children: project.technologies.asMap().entries.map((entry) {
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 600 + (entry.key * 100)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8 : 10,
                          vertical: isMobile ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: isMobile ? 10 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _buildProjectButton(
                    'GitHub',
                    Icons.code_rounded,
                    () {
                      // Handle GitHub link
                      debugPrint('Open GitHub: ${project.githubUrl}');
                    },
                    isMobile,
                    context,
                  ),
                ),
                SizedBox(width: isMobile ? 8 : 12),
                Expanded(
                  child: _buildProjectButton(
                    'Live Demo',
                    Icons.launch_rounded,
                    () {
                      // Handle demo link
                      debugPrint('Open Demo: ${project.demoUrl}');
                    },
                    isMobile,
                    context,
                  ),
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
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 8 : 10,
            horizontal: isMobile ? 12 : 16,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isMobile ? 16 : 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: isMobile ? 4 : 6),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
            ],
          ),
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

  const Project(
    this.title,
    this.description,
    this.technologies,
    this.githubUrl,
    this.demoUrl,
  );
}
