import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../utils/typewriter_text.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isMobile = size.width < 768;
    
    return Container(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          // Animated floating background elements
          ...List.generate(6, (index) => AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              final colors = [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary,
              ];
              return Positioned(
                top: 50 + (index * 150) + (_floatingAnimation.value * (index.isEven ? 1 : -1)),
                left: (index.isEven ? 50 : size.width - 150) + _floatingAnimation.value,
                child: Transform.rotate(
                  angle: _floatingController.value * 2 * 3.14159,
                  child: Container(
                    width: 60 + (index * 10),
                    height: 60 + (index * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          colors[index % 3].withOpacity(0.2),
                          colors[index % 3].withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
          
          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isMobile ? size.width - 40 : (isTablet ? 700 : 900),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 40,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Animated main title with multi-color gradient
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: ShaderMask(
                                      shaderCallback: (bounds) => LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context).colorScheme.secondary,
                                          Theme.of(context).colorScheme.tertiary,
                                          Theme.of(context).colorScheme.primary,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: const [0.0, 0.3, 0.7, 1.0],
                                      ).createShader(bounds),
                                      child: Text(
                                        'John Developer',
                                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                          fontSize: isMobile ? 40 : (isTablet ? 56 : 72),
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: -2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              SizedBox(height: isMobile ? 20 : 30),
                              
                              // Glassmorphism subtitle container
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 20 : 30,
                                  vertical: isMobile ? 12 : 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('🚀', style: TextStyle(fontSize: isMobile ? 20 : 24)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Flutter Developer & Mobile App Specialist',
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        fontSize: isMobile ? 16 : (isTablet ? 20 : 24),
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: isMobile ? 30 : 40),
                              
                              // Enhanced typewriter animation
                              Container(
                                height: isMobile ? 80 : 100,
                                child: TypewriterText(
                                  texts: const [
                                    '💻 Building Beautiful Apps',
                                    '🎨 Creating Amazing UIs',
                                    '⚡ Fast & Responsive',
                                    '🌟 Modern Animations',
                                    '📱 Cross-Platform Magic',
                                  ],
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontSize: isMobile ? 18 : (isTablet ? 22 : 26),
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: isMobile ? 40 : 60),
                              
                              // Enhanced action buttons with micro-animations
                              AnimatedBuilder(
                                animation: _floatingController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatingAnimation.value * 0.5),
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: isMobile ? 15 : 25,
                                      runSpacing: 15,
                                      children: [
                                        _buildEnhancedActionButton(
                                          context,
                                          '✨ View My Work',
                                          Icons.rocket_launch,
                                          () {},
                                          isMobile,
                                          isPrimary: true,
                                        ),
                                        _buildEnhancedActionButton(
                                          context,
                                          '💬 Get In Touch',
                                          Icons.chat_bubble_outline,
                                          () {},
                                          isMobile,
                                          isPrimary: false,
                                        ),
                                        _buildEnhancedActionButton(
                                          context,
                                          '📄 Resume',
                                          Icons.download,
                                          () {},
                                          isMobile,
                                          isPrimary: false,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              
                              SizedBox(height: isMobile ? 60 : 100),
                              
                              // Enhanced scroll indicator
                              AnimatedBuilder(
                                animation: _floatingController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatingAnimation.value * 0.3),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('👇', style: TextStyle(fontSize: 16)),
                                              SizedBox(width: 8),
                                              Text(
                                                'Scroll to explore my work',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontSize: isMobile ? 12 : 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        AnimatedBuilder(
                                          animation: _pulseController,
                                          builder: (context, child) {
                                            return Transform.scale(
                                              scale: _pulseAnimation.value,
                                              child: Icon(
                                                Icons.keyboard_double_arrow_down,
                                                color: Theme.of(context).colorScheme.primary,
                                                size: isMobile ? 28 : 32,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActionButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
    bool isMobile, {
    required bool isPrimary,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 28,
              vertical: isMobile ? 14 : 18,
            ),
            decoration: BoxDecoration(
              gradient: isPrimary 
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surface.withOpacity(0.1),
                      Theme.of(context).colorScheme.surface.withOpacity(0.05),
                    ],
                  ),
              borderRadius: BorderRadius.circular(25),
              border: isPrimary 
                ? null 
                : Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    width: 1.5,
                  ),
              boxShadow: [
                BoxShadow(
                  color: isPrimary 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  blurRadius: isPrimary ? 15 : 10,
                  spreadRadius: isPrimary ? 2 : 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isPrimary 
                    ? Colors.white 
                    : Theme.of(context).colorScheme.primary,
                  size: isMobile ? 18 : 22,
                ),
                SizedBox(width: isMobile ? 8 : 12),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isPrimary 
                      ? Colors.white 
                      : Theme.of(context).colorScheme.primary,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
