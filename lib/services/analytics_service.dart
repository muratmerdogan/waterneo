import 'package:firebase_analytics/firebase_analytics.dart';

/// Analytics Service - Firebase Analytics entegrasyonu
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Su ekleme event'i
  Future<void> logWaterAdded(int amount) async {
    await _analytics.logEvent(
      name: 'water_added',
      parameters: {
        'amount_ml': amount,
      },
    );
  }

  /// Hedef tamamlama event'i
  Future<void> logGoalReached() async {
    await _analytics.logEvent(name: 'goal_reached');
  }

  /// Streak event'i
  Future<void> logStreak(int days) async {
    await _analytics.logEvent(
      name: 'streak_achieved',
      parameters: {
        'days': days,
      },
    );
  }

  /// Premium satın alma event'i
  Future<void> logPremiumPurchase(String plan) async {
    await _analytics.logEvent(
      name: 'premium_purchased',
      parameters: {
        'plan': plan,
      },
    );
  }

  /// Ekran görüntüleme
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  /// Kullanıcı özelliği ayarla
  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }
}

