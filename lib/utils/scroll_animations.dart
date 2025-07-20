import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollAnimationController extends ChangeNotifier {
  ScrollController? _scrollController;
  double _scrollOffset = 0.0;
  double _scrollVelocity = 0.0;
  bool _disposed = false;

  ScrollController? get scrollController => _scrollController;
  double get scrollOffset => _scrollOffset;
  double get scrollVelocity => _scrollVelocity;

  ScrollAnimationController() {
    _scrollController = ScrollController();
    _scrollController?.addListener(_onScroll);
  }

  double getParallaxOffset(double factor) => _disposed ? 0.0 : _scrollOffset * factor;
  double getShadowIntensity() => _disposed ? 0.0 : (_scrollOffset / 100).clamp(0.0, 1.0);

  void _onScroll() {
    if (_disposed || _scrollController == null) return;

    final newOffset = _scrollController!.offset;
    _scrollVelocity = newOffset - _scrollOffset;
    _scrollOffset = newOffset;

    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _scrollController?.removeListener(_onScroll);
      _scrollController?.dispose();
      _scrollController = null;
      super.dispose();
    }
  }

  Future<void> scrollToSection(GlobalKey key) async {
    if (_disposed || _scrollController == null || key.currentContext == null) return;

    try {
      final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final position = renderBox.localToGlobal(Offset.zero);

      if (!_disposed && _scrollController != null) {
        await _scrollController!.animateTo(
          position.dy - 80,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOutCubic,
        );
      }
    } catch (e) {
      // Silently handle any disposal-related errors
    }
  }
}

class SafeScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset startOffset;
  final double startScale;
  final double startOpacity;
  final Curve curve;

  const SafeScrollRevealWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.startOffset = const Offset(0, 50),
    this.startScale = 0.9,
    this.startOpacity = 0.0,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<SafeScrollRevealWidget> createState() => _SafeScrollRevealWidgetState();
}

class _SafeScrollRevealWidgetState extends State<SafeScrollRevealWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    if (!mounted) return;

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = CurvedAnimation(parent: _controller!, curve: widget.curve);

    // Safe post-frame callback
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller != null) {
        _startAnimation();
      }
    });
  }

  void _startAnimation() {
    if (!mounted || _hasAnimated || _controller == null) return;

    _hasAnimated = true;
    _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _animation = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animation == null) {
      return widget.child; // Return child immediately if animation isn't ready
    }

    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, child) {
        final value = _animation?.value ?? 1.0;
        return Transform.translate(
          offset: Offset(
            widget.startOffset.dx * (1 - value),
            widget.startOffset.dy * (1 - value),
          ),
          child: Transform.scale(
            scale: widget.startScale + (1 - widget.startScale) * value,
            child: Opacity(
              opacity: widget.startOpacity + (1 - widget.startOpacity) * value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class SafeShadowAnimationWidget extends StatefulWidget {
  final Widget child;
  final double maxShadowIntensity;
  final Color shadowColor;
  final double blurRadius;
  final Offset shadowOffset;

  const SafeShadowAnimationWidget({
    super.key,
    required this.child,
    this.maxShadowIntensity = 0.3,
    this.shadowColor = Colors.black,
    this.blurRadius = 20.0,
    this.shadowOffset = const Offset(0, 10),
  });

  @override
  State<SafeShadowAnimationWidget> createState() => _SafeShadowAnimationWidgetState();
}

class _SafeShadowAnimationWidgetState extends State<SafeShadowAnimationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.maxShadowIntensity,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _animation = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animation == null) {
      return widget.child;
    }

    return MouseRegion(
      onEnter: (_) {
        if (mounted && _controller != null) {
          _controller!.forward();
        }
      },
      onExit: (_) {
        if (mounted && _controller != null) {
          _controller!.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) {
          final value = _animation?.value ?? 0.0;
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor.withOpacity(value),
                  blurRadius: widget.blurRadius * value,
                  offset: widget.shadowOffset * value,
                  spreadRadius: 2 * value,
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
