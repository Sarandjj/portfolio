import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with TickerProviderStateMixin {
  late AnimationController _timelineController;
  late List<Animation<double>> _experienceAnimations;

  final List<Experience> _experiences = [
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
  void initState() {
    super.initState();
    _timelineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _experienceAnimations = List.generate(
      _experiences.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _timelineController,
          curve: Interval(
            index * 0.2,
            (index * 0.2) + 0.5,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timelineController.forward();
    });
  }

  @override
  void dispose() {
    _timelineController.dispose();
    super.dispose();
  }

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
                ),
              ),
              SizedBox(height: isMobile ? 40 : 60),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _experiences.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _experienceAnimations[index],
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          isMobile 
                              ? 0 
                              : (index % 2 == 0 ? -50 : 50) * (1 - _experienceAnimations[index].value),
                          0,
                        ),
                        child: Opacity(
                          opacity: _experienceAnimations[index].value,
                          child: _buildTimelineItem(_experiences[index], index, isMobile, isTablet),
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
    );
  }

  Widget _buildTimelineItem(Experience experience, int index, bool isMobile, bool isTablet) {
    final isLeft = index % 2 == 0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 20),
      child: isMobile
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimelineDot(),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildExperienceCard(experience, isMobile, isTablet),
                ),
              ],
            )
          : Row(
              children: [
                if (isLeft) ...[
                  Expanded(
                    child: _buildExperienceCard(experience, isMobile, isTablet),
                  ),
                  SizedBox(width: isTablet ? 16 : 20),
                  _buildTimelineDot(),
                  SizedBox(width: isTablet ? 16 : 20),
                  const Expanded(child: SizedBox()),
                ] else ...[
                  const Expanded(child: SizedBox()),
                  SizedBox(width: isTablet ? 16 : 20),
                  _buildTimelineDot(),
                  SizedBox(width: isTablet ? 16 : 20),
                  Expanded(
                    child: _buildExperienceCard(experience, isMobile, isTablet),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildExperienceCard(Experience experience, bool isMobile, bool isTablet) {
    return GlassContainer(
      padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 18 : 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            experience.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
            ),
          ),
          SizedBox(height: isMobile ? 6 : 8),
          Text(
            experience.company,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          SizedBox(height: isMobile ? 3 : 4),
          Text(
            experience.duration,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: isMobile ? 12 : 14,
            ),
          ),
          SizedBox(height: isMobile ? 10 : 12),
          Text(
            experience.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineDot() {
    return GlassContainer(
      width: 20,
      height: 20,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class Experience {
  final String title;
  final String company;
  final String duration;
  final String description;

  Experience(this.title, this.company, this.duration, this.description);
}
