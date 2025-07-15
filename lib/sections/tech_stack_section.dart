import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../utils/scroll_animations.dart';

class TechStackSection extends StatefulWidget {
  const TechStackSection({super.key});

  @override
  State<TechStackSection> createState() => _TechStackSectionState();
}

class _TechStackSectionState extends State<TechStackSection>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _staggerController;
  late List<Animation<double>> _itemAnimations;

  final List<TechItem> _techItems = [
    TechItem('Flutter', Icons.flutter_dash, const Color(0xFF02569B)),
    TechItem('Firebase', Icons.local_fire_department, const Color(0xFFFF6F00)),
    TechItem('Node.js', Icons.javascript, const Color(0xFF689F63)),
    TechItem('MongoDB', Icons.storage, const Color(0xFF47A248)),
    TechItem('SQL', Icons.table_chart, const Color(0xFF336791)),
    TechItem('Azure', Icons.cloud, const Color(0xFF0078D4)),
    TechItem('Docker', Icons.inventory, const Color(0xFF2496ED)),
    TechItem('Git', Icons.account_tree, const Color(0xFFF05032)),
    TechItem('Dart', Icons.code, const Color(0xFF0175C2)),
    TechItem('API', Icons.api, const Color(0xFF6366F1)),
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _itemAnimations = List.generate(
      _techItems.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(index * 0.1, (index * 0.1) + 0.3, curve: Curves.easeOut),
        ),
      ),
    );

    // Start animation when section is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _staggerController.dispose();
    super.dispose();
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
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? size.width - 40 : (isTablet ? 700 : 1000),
            ),
            child: Column(
              children: [
                ScrollRevealWidget(
                  startOffset: const Offset(0, 30),
                  duration: const Duration(milliseconds: 800),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotationTransition(
                        turns: _rotationController,
                        child: Icon(
                          Icons.settings,
                          size: isMobile ? 24 : (isTablet ? 28 : 32),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: isMobile ? 12 : 16),
                      Text(
                        'Tech Stack',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 40 : 60),
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
                    return AnimatedBuilder(
                      animation: _itemAnimations[index],
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _itemAnimations[index].value,
                          child: _buildTechCard(_techItems[index], isMobile),
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
    );
  }

  Widget _buildTechCard(TechItem item, bool isMobile) {
    return ShadowAnimationWidget(
      maxShadowIntensity: 0.4,
      shadowColor: item.color,
      blurRadius: 25.0,
      shadowOffset: const Offset(0, 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surface.withOpacity(0.1),
                  item.color.withOpacity(0.05),
                ],
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
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
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
                        child: Icon(
                          item.icon,
                          size: isMobile ? 32 : 40,
                          color: item.color,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: isMobile ? 12 : 16),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 12 : 14,
                    color: item.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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

  TechItem(this.name, this.icon, this.color);
}
