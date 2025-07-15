import 'package:flutter/material.dart';

class SmoothScrollController {
  late ScrollController _scrollController;
  
  ScrollController get scrollController => _scrollController;

  SmoothScrollController() {
    _scrollController = ScrollController();
  }

  void dispose() {
    _scrollController.dispose();
  }

  Future<void> scrollToSection(double offset) async {
    await _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Future<void> scrollToTop() async {
    await scrollToSection(0);
  }
}
