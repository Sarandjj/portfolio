// lib/widgets/loading_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingScreen extends StatefulWidget {
  final VoidCallback onLoadingComplete;

  const LoadingScreen({super.key, required this.onLoadingComplete});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.5)));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));

    _initializeParticles();
    _startAnimations();
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 3 + 1,
          speed: random.nextDouble() * 0.015 + 0.005,
          opacity: random.nextDouble() * 0.4 + 0.3,
        ),
      );
    }
  }

  void _startAnimations() async {
    _mainController.forward();

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      await _mainController.reverse();
      widget.onLoadingComplete();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF059669), // Emerald
              Color(0xFF0EA5E9), // Sky Blue
              Color(0xFF10B981), // Green
              Color(0xFF3B82F6), // Blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated Particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(_particles, _particleController.value),
                  size: Size.infinite,
                );
              },
            ),

            // Loading Content
            Center(
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Logo
                          AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.4),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Transform.rotate(
                                  angle: _rotationController.value * 2 * math.pi,
                                  child: const Icon(
                                    Icons.flutter_dash,
                                    color: Color(0xFF059669),
                                    size: 60,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 40),

                          // Loading Text
                          Text(
                            'Loading Portfolio...',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Progress Bar
                          Container(
                            width: 250,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white.withOpacity(0.3),
                            ),
                            child: AnimatedBuilder(
                              animation: _mainController,
                              builder: (context, child) {
                                return FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _mainController.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Particle {
  double x, y, size, speed, opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      final currentY = (particle.y + animationValue * particle.speed) % 1.0;
      final currentX =
          (particle.x + math.sin(animationValue * 2 * math.pi + particle.y * 10) * 0.05) %
          1.0;

      paint.color = Colors.white.withOpacity(particle.opacity);

      canvas.drawCircle(
        Offset(currentX * size.width, currentY * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
