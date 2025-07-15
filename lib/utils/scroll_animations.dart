import 'package:flutter/material.dart';
import 'dart:math' as math;

class ScrollAnimationController extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  double _scrollVelocity = 0.0;
  
  ScrollController get scrollController => _scrollController;
  double get scrollOffset => _scrollOffset;
  double get scrollVelocity => _scrollVelocity;
  
  // Calculate parallax effect
  double getParallaxOffset(double factor) {
    return _scrollOffset * factor;
  }
  
  // Calculate shadow intensity based on scroll
  double getShadowIntensity() {
    final intensity = (_scrollOffset / 100).clamp(0.0, 1.0);
    return intensity;
  }

  ScrollAnimationController() {
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final newOffset = _scrollController.offset;
    _scrollVelocity = newOffset - _scrollOffset;
    _scrollOffset = newOffset;
    notifyListeners();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> scrollToSection(GlobalKey key) async {
    if (key.currentContext != null) {
      final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      
      await _scrollController.animateTo(
        position.dy - 80,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}

class ScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset startOffset;
  final double startScale;
  final double startOpacity;
  final Curve curve;
  final double triggerOffset;

  const ScrollRevealWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.startOffset = const Offset(0, 50),
    this.startScale = 0.9,
    this.startOpacity = 0.0,
    this.curve = Curves.easeOutCubic,
    this.triggerOffset = 100,
  });

  @override
  State<ScrollRevealWidget> createState() => _ScrollRevealWidgetState();
}

class _ScrollRevealWidgetState extends State<ScrollRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (_hasAnimated) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    if (position.dy + size.height >= widget.triggerOffset &&
        position.dy <= screenHeight - widget.triggerOffset) {
      _hasAnimated = true;
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            widget.startOffset.dx * (1 - _animation.value),
            widget.startOffset.dy * (1 - _animation.value),
          ),
          child: Transform.scale(
            scale: widget.startScale + (1 - widget.startScale) * _animation.value,
            child: Opacity(
              opacity: widget.startOpacity + (1 - widget.startOpacity) * _animation.value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class ParallaxWidget extends StatelessWidget {
  final Widget child;
  final double speed;

  const ParallaxWidget({
    super.key,
    required this.child,
    this.speed = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 0), // Enhanced parallax can be added later
      child: child,
    );
  }
}

class ShadowAnimationWidget extends StatefulWidget {
  final Widget child;
  final double maxShadowIntensity;
  final Color shadowColor;
  final double blurRadius;
  final Offset shadowOffset;
  final Duration animationDuration;

  const ShadowAnimationWidget({
    super.key,
    required this.child,
    this.maxShadowIntensity = 0.3,
    this.shadowColor = Colors.black,
    this.blurRadius = 20.0,
    this.shadowOffset = const Offset(0, 10),
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<ShadowAnimationWidget> createState() => _ShadowAnimationWidgetState();
}

class _ShadowAnimationWidgetState extends State<ShadowAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shadowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: widget.maxShadowIntensity,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        _animationController.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _shadowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor.withOpacity(_shadowAnimation.value),
                  blurRadius: widget.blurRadius * _shadowAnimation.value,
                  offset: widget.shadowOffset * _shadowAnimation.value,
                  spreadRadius: 2 * _shadowAnimation.value,
                ),
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class StaggeredAnimationWidget extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration animationDuration;
  final Offset startOffset;
  final double startOpacity;

  const StaggeredAnimationWidget({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.animationDuration = const Duration(milliseconds: 600),
    this.startOffset = const Offset(0, 30),
    this.startOpacity = 0.0,
  });

  @override
  State<StaggeredAnimationWidget> createState() => _StaggeredAnimationWidgetState();
}

class _StaggeredAnimationWidgetState extends State<StaggeredAnimationWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );
    _animations = _controllers.map((controller) =>
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
    ).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startStaggeredAnimation() {
    if (_hasStarted) return;
    _hasStarted = true;
    
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _startStaggeredAnimation());

    return Column(
      children: List.generate(widget.children.length, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: widget.startOffset * (1 - _animations[index].value),
              child: Opacity(
                opacity: widget.startOpacity + (1 - widget.startOpacity) * _animations[index].value,
                child: widget.children[index],
              ),
            );
          },
        );
      }),
    );
  }
}