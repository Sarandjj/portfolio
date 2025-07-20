// lib/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: analytics);

  // Track page views
  static Future<void> logPageView({required String pageName, String? pageClass}) async {
    await analytics.logScreenView(
      screenName: pageName,
      screenClass: pageClass ?? pageName,
    );

    if (kDebugMode) {
      print('📊 Analytics: Page view - $pageName');
    }
  }

  // Track button clicks
  static Future<void> logButtonClick({
    required String buttonName,
    String? section,
    Map<String, Object>? parameters,
  }) async {
    await analytics.logEvent(
      name: 'button_click',
      parameters: {
        'button_name': buttonName,
        'section': section ?? 'unknown',
        ...?parameters,
      },
    );

    if (kDebugMode) {
      print('📊 Analytics: Button click - $buttonName');
    }
  }

  // Track section views
  static Future<void> logSectionView({
    required String sectionName,
    int? timeSpent,
  }) async {
    await analytics.logEvent(
      name: 'section_view',
      parameters: {
        'section_name': sectionName,
        if (timeSpent != null) 'time_spent_seconds': timeSpent,
      },
    );

    if (kDebugMode) {
      print('📊 Analytics: Section view - $sectionName');
    }
  }

  // Track contact form submissions
  static Future<void> logContactFormSubmission({
    required String formType,
    bool successful = true,
  }) async {
    await analytics.logEvent(
      name: 'contact_form_submission',
      parameters: {'form_type': formType, 'successful': successful},
    );

    if (kDebugMode) {
      print('📊 Analytics: Contact form - $formType (Success: $successful)');
    }
  }

  // Track project views
  static Future<void> logProjectView({
    required String projectName,
    String? projectType,
  }) async {
    await analytics.logEvent(
      name: 'project_view',
      parameters: {'project_name': projectName, 'project_type': projectType ?? 'unknown'},
    );

    if (kDebugMode) {
      print('📊 Analytics: Project view - $projectName');
    }
  }

  // Track download events (resume, etc.)
  static Future<void> logDownload({required String fileName, String? fileType}) async {
    await analytics.logEvent(
      name: 'file_download',
      parameters: {'file_name': fileName, 'file_type': fileType ?? 'unknown'},
    );

    if (kDebugMode) {
      print('📊 Analytics: Download - $fileName');
    }
  }

  // Track theme changes
  static Future<void> logThemeChange({required String newTheme}) async {
    await analytics.logEvent(name: 'theme_change', parameters: {'new_theme': newTheme});

    if (kDebugMode) {
      print('📊 Analytics: Theme change - $newTheme');
    }
  }

  // Track user engagement
  static Future<void> logEngagementEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    await analytics.logEvent(name: eventName, parameters: parameters);

    if (kDebugMode) {
      print('📊 Analytics: Engagement - $eventName');
    }
  }

  // Set user properties
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await analytics.setUserProperty(name: name, value: value);

    if (kDebugMode) {
      print('📊 Analytics: User property - $name: $value');
    }
  }
}
