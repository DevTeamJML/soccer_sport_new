import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future logScreens({required String name}) async {
    await _analytics.setCurrentScreen(screenName: name);
  }

  Future setUserId({required String userId}) async {
    await _analytics.setUserId(id: userId);
  }
}
