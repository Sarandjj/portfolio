// lib/widgets/scroll_reveal.dart
import 'package:flutter/material.dart';

class ScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset startOffset;
  final double startOpacity;
  final Curve curve;

  const ScrollRevealWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.startOffset = const Offset(0, 50),
    this.startOpacity = 0.0,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<ScrollRevealWidget> createState() => _ScrollRevealWidgetState();
}

class _ScrollRevealWidgetState extends State<ScrollRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && !_hasAnimated) {
        _hasAnimated = true;
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            widget.startOffset.dx * (1 - _animation.value),
            widget.startOffset.dy * (1 - _animation.value),
          ),
          child: Opacity(
            opacity: widget.startOpacity + (1 - widget.startOpacity) * _animation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
