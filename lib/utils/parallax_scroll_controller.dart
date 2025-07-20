// lib/utils/parallax_scroll_controller.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

class ParallaxScrollController extends ChangeNotifier {
  ScrollController? _scrollController;
  double _scrollOffset = 0.0;
  bool _disposed = false;

  ScrollController? get scrollController => _scrollController;
  double get scrollOffset => _scrollOffset;

  ParallaxScrollController() {
    _scrollController = ScrollController();
    _scrollController?.addListener(_onScroll);
  }

  double getParallaxOffset(double factor, {double speed = 0.5}) {
    return _disposed ? 0.0 : _scrollOffset * factor * speed;
  }

  double getRotationOffset(double factor) {
    return _disposed ? 0.0 : (_scrollOffset * factor * 0.001);
  }

  double getScaleOffset(double factor) {
    return _disposed ? 1.0 : (1.0 + (_scrollOffset * factor * 0.0001)).clamp(0.8, 1.2);
  }

  void _onScroll() {
    if (_disposed || _scrollController == null) return;
    _scrollOffset = _scrollController!.offset;
    notifyListeners();
  }

  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _scrollController?.removeListener(_onScroll);
      _scrollController?.dispose();
      super.dispose();
    }
  }
}

class FloatingParticles extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final double minSize;
  final double maxSize;
  final double speed;

  const FloatingParticles({
    super.key,
    this.particleCount = 30,
    this.particleColor = Colors.blue,
    this.minSize = 2.0,
    this.maxSize = 6.0,
    this.speed = 1.0,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<FloatingParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 10), vsync: this)
      ..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(
        FloatingParticle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: widget.minSize + random.nextDouble() * (widget.maxSize - widget.minSize),
          speedX: (random.nextDouble() - 0.5) * widget.speed * 0.02,
          speedY: (random.nextDouble() - 0.5) * widget.speed * 0.02,
          opacity: random.nextDouble() * 0.6 + 0.2,
          phase: random.nextDouble() * 2 * math.pi,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FloatingParticlePainter(
            _particles,
            _controller.value,
            widget.particleColor,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class FloatingParticle {
  double x, y, size, speedX, speedY, opacity, phase;

  FloatingParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
    required this.phase,
  });
}

class FloatingParticlePainter extends CustomPainter {
  final List<FloatingParticle> particles;
  final double animationValue;
  final Color particleColor;

  FloatingParticlePainter(this.particles, this.animationValue, this.particleColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      final time = animationValue * 2 * math.pi + particle.phase;
      final floatX = particle.x + math.sin(time * 0.5) * 0.02;
      final floatY = particle.y + math.cos(time * 0.3) * 0.02;

      final currentX = (floatX + particle.speedX * animationValue) % 1.0;
      final currentY = (floatY + particle.speedY * animationValue) % 1.0;

      final pulseOpacity = particle.opacity + math.sin(time) * 0.2;

      paint.color = particleColor.withOpacity(pulseOpacity.clamp(0.0, 1.0));

      canvas.drawCircle(
        Offset(currentX * size.width, currentY * size.height),
        particle.size + math.sin(time * 2) * 0.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
