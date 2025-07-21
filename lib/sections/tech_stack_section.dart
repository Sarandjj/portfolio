import 'package:flutter/material.dart';

class TechStackSection extends StatelessWidget {
  const TechStackSection({super.key});

  final List<TechItem> _techItems = const [
    TechItem('Flutter', Icons.flutter_dash, Color(0xFF02569B)),
    TechItem('Firebase', Icons.local_fire_department, Color(0xFFFF6F00)),
    TechItem('Node.js', Icons.javascript, Color(0xFF689F63)),
    TechItem('MongoDB', Icons.storage, Color(0xFF47A248)),
    // TechItem('SQL', Icons.table_chart, Color(0xFF336791)),
    // TechItem('Azure', Icons.cloud, Color(0xFF0078D4)),
    TechItem('Docker', Icons.inventory, Color(0xFF2496ED)),
    TechItem('Git', Icons.account_tree, Color(0xFFF05032)),
    TechItem('Dart', Icons.code, Color(0xFF0175C2)),
    TechItem('API', Icons.api, Color(0xFF6366F1)),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isMobile = size.width < 768;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 80 * (1 - value)),
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
                    maxWidth: isMobile ? size.width - 40 : (isTablet ? 700 : 1000),
                  ),
                  child: Column(
                    children: [
                      // Header with rotating icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            duration: const Duration(seconds: 4),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, rotationValue, child) {
                              return Transform.rotate(
                                angle: rotationValue * 6.28319, // 2π for full rotation
                                child: Icon(
                                  Icons.settings,
                                  size: isMobile ? 24 : (isTablet ? 28 : 32),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: isMobile ? 12 : 16),
                          Text(
                            'Tech Stack',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 40 : 60),

                      // Tech items grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
                          crossAxisSpacing: isMobile ? 15 : 20,
                          mainAxisSpacing: isMobile ? 15 : 20,
                          childAspectRatio: 1,
                        ),
                        itemCount: _techItems.length,
                        itemBuilder: (context, index) {
                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 600 + (index * 100)),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, animValue, child) {
                              return Transform.scale(
                                scale: animValue,
                                child: _buildTechCard(
                                  _techItems[index],
                                  isMobile,
                                  context,
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

  Widget _buildTechCard(TechItem item, bool isMobile, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          debugPrint('Tapped on ${item.name}');
        },
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).cardColor, item.color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: item.color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: item.color.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            item.color.withOpacity(0.2),
                            item.color.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Icon(item.icon, size: isMobile ? 32 : 40, color: item.color),
                    ),
                  );
                },
              ),
              SizedBox(height: isMobile ? 12 : 16),

              // Name
              Text(
                item.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: isMobile ? 12 : 14,
                  // color: item.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TechItem {
  final String name;
  final IconData icon;
  final Color color;

  const TechItem(this.name, this.icon, this.color);
}
