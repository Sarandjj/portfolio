import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration pauseDuration;

  const TypewriterText({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.pauseDuration = const Duration(seconds: 2),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  int _currentTextIndex = 0;
  String _currentDisplayText = '';
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _startTypewriterAnimation();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  void _startTypewriterAnimation() async {
    while (mounted) {
      final currentText = widget.texts[_currentTextIndex];
      
      // Type out the text
      for (int i = 0; i <= currentText.length; i++) {
        if (!mounted) return;
        setState(() {
          _currentDisplayText = currentText.substring(0, i);
          _isTyping = true;
        });
        await Future.delayed(widget.typingSpeed);
      }

      // Pause
      await Future.delayed(widget.pauseDuration);

      // Delete the text
      for (int i = currentText.length; i >= 0; i--) {
        if (!mounted) return;
        setState(() {
          _currentDisplayText = currentText.substring(0, i);
          _isTyping = false;
        });
        await Future.delayed(widget.typingSpeed ~/ 2);
      }

      // Move to next text
      setState(() {
        _currentTextIndex = (_currentTextIndex + 1) % widget.texts.length;
      });

      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _currentDisplayText,
          style: widget.style,
        ),
        AnimatedBuilder(
          animation: _blinkController,
          builder: (context, child) {
            return Opacity(
              opacity: _blinkController.value,
              child: Container(
                width: 2,
                height: (widget.style?.fontSize ?? 24) * 1.2,
                color: widget.style?.color ?? Theme.of(context).colorScheme.primary,
              ),
            );
          },
        ),
      ],
    );
  }
}
