import 'package:flutter/material.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const List<Experience> _experiences = [
    Experience(
      'Senior Flutter Developer',
      'Tech Solutions Inc.',
      '2022 - Present',
      'Leading mobile app development projects using Flutter, implementing best practices for code quality and performance optimization.',
    ),
    Experience(
      'Mobile App Developer',
      'Innovation Labs',
      '2020 - 2022',
      'Developed cross-platform mobile applications, collaborated with UI/UX designers to create intuitive user interfaces.',
    ),
    Experience(
      'Junior Developer',
      'StartUp Studio',
      '2019 - 2020',
      'Started career in mobile development, learned Flutter framework and contributed to various client projects.',
    ),
    Experience(
      'Computer Science Degree',
      'University of Technology',
      '2015 - 2019',
      'Bachelor\'s degree in Computer Science with focus on software engineering and mobile application development.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
        vertical: isMobile ? 40 : (isTablet ? 60 : 80),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? size.width - 40 : (isTablet ? 600 : 800),
          ),
          child: Column(
            children: [
              Text(
                'Experience & Education',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isMobile ? 40 : 60),

              // Timeline
              Column(
                children: _experiences.asMap().entries.map((entry) {
                  final index = entry.key;
                  final experience = entry.value;
                  return _buildTimelineItem(
                    experience,
                    index,
                    isMobile,
                    isTablet,
                    context,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    Experience experience,
    int index,
    bool isMobile,
    bool isTablet,
    BuildContext context,
  ) {
    final isLeft = index % 2 == 0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 20),
      child: isMobile
          ? _buildMobileTimelineItem(experience, isMobile, isTablet, context)
          : _buildDesktopTimelineItem(experience, isLeft, isMobile, isTablet, context),
    );
  }

  Widget _buildMobileTimelineItem(
    Experience experience,
    bool isMobile,
    bool isTablet,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildTimelineDot(context),
            if (_experiences.indexOf(experience) < _experiences.length - 1)
              Container(
                width: 2,
                height: 80,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildExperienceCard(experience, isMobile, isTablet, context)),
      ],
    );
  }

  Widget _buildDesktopTimelineItem(
    Experience experience,
    bool isLeft,
    bool isMobile,
    bool isTablet,
    BuildContext context,
  ) {
    return Stack(
      children: [
        // Timeline line
        Positioned(
          left: isTablet ? (300 - 1) : (400 - 1),
          top: 30,
          child: Container(
            width: 2,
            height: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        // Content
        Row(
          children: [
            if (isLeft) ...[
              Expanded(
                child: _buildExperienceCard(experience, isMobile, isTablet, context),
              ),
              SizedBox(width: isTablet ? 16 : 20),
              _buildTimelineDot(context),
              SizedBox(width: isTablet ? 16 : 20),
              const Expanded(child: SizedBox()),
            ] else ...[
              const Expanded(child: SizedBox()),
              SizedBox(width: isTablet ? 16 : 20),
              _buildTimelineDot(context),
              SizedBox(width: isTablet ? 16 : 20),
              Expanded(
                child: _buildExperienceCard(experience, isMobile, isTablet, context),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildExperienceCard(
    Experience experience,
    bool isMobile,
    bool isTablet,
    BuildContext context,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 18 : 20)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).cardColor.withOpacity(0.8),
            ],
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              experience.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: isMobile ? 18 : (isTablet ? 20 : 22),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isMobile ? 6 : 8),
            Row(
              children: [
                Icon(
                  Icons.business,
                  size: isMobile ? 16 : 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    experience.company,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 4 : 6),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: isMobile ? 14 : 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  experience.duration,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isMobile ? 12 : 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Text(
                experience.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: isMobile ? 12 : 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineDot(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Theme.of(context).colorScheme.surface, width: 3),
      ),
      child: Icon(Icons.circle, size: 8, color: Theme.of(context).colorScheme.surface),
    );
  }
}

class Experience {
  final String title;
  final String company;
  final String duration;
  final String description;

  const Experience(this.title, this.company, this.duration, this.description);
}
