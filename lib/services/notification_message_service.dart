import '../models/daily_summary.dart';
import '../models/user_settings.dart';

/// Kişiselleştirilmiş bildirim mesajları servisi
class NotificationMessageService {
  static final NotificationMessageService _instance =
      NotificationMessageService._internal();
  factory NotificationMessageService() => _instance;
  NotificationMessageService._internal();

  /// Saate göre selamlama mesajları
  final List<String> _morningMessages = [
    'Good morning! Start your day with a refreshing glass of water 💧',
    'Morning! Your body needs hydration after a night\'s rest. Drink up!',
    'Rise and hydrate! A glass of water will kickstart your day 🌅',
    'Good morning! Time to fuel your body with some H2O',
  ];

  final List<String> _afternoonMessages = [
    'Afternoon check-in: How about a glass of water to stay refreshed?',
    'Midday reminder: Your body is working hard, keep it hydrated!',
    'Afternoon boost: A sip of water can help you stay focused 💪',
    'Don\'t forget to hydrate during your busy afternoon!',
  ];

  final List<String> _eveningMessages = [
    'Evening reminder: Keep hydrating until bedtime!',
    'Wind down with some water - your body will thank you',
    'Evening check: Stay hydrated as you wrap up your day',
    'Don\'t forget your evening hydration routine!',
  ];

  /// İlerleme bazlı mesajlar
  final List<String> _lowProgressMessages = [
    'You\'re just getting started! A glass of water will help you reach your goal',
    'Every drop counts! Let\'s build up your hydration for today',
    'Starting strong? A sip now sets you up for success',
    'Early days! Keep the momentum going with some water',
  ];

  final List<String> _midProgressMessages = [
    'You\'re making great progress! Keep it up with another glass',
    'Halfway there! Your body is thanking you for staying hydrated',
    'Nice work so far! A bit more water and you\'ll hit your goal',
    'You\'re on track! Don\'t stop now, keep hydrating',
  ];

  final List<String> _highProgressMessages = [
    'Almost there! Just a bit more water and you\'ll reach your goal 🎯',
    'So close! You\'re doing amazing, finish strong!',
    'You\'re crushing it! One more glass and you\'re done',
    'Final stretch! You\'ve got this, keep going!',
  ];

  final List<String> _achievementMessages = [
    'Congratulations! You\'ve reached your daily goal! 🎉',
    'Amazing work! You\'ve hit your hydration target today',
    'Goal achieved! Your body is well-hydrated today',
    'Perfect! You\'ve completed your daily water intake goal',
  ];

  /// Kişiselleştirilmiş mesaj oluştur
  Future<String> generatePersonalizedMessage({
    required DailySummary todaySummary,
    required UserSettings userSettings,
    required DateTime currentTime,
  }) async {
    final hour = currentTime.hour;
    final progress = todaySummary.completionPercentage;
    final percentage = (progress * 100).round();

    // Saate göre mesaj seç
    String timeBasedMessage;
    if (hour >= 6 && hour < 12) {
      timeBasedMessage = _morningMessages[
          DateTime.now().millisecond % _morningMessages.length];
    } else if (hour >= 12 && hour < 18) {
      timeBasedMessage = _afternoonMessages[
          DateTime.now().millisecond % _afternoonMessages.length];
    } else {
      timeBasedMessage = _eveningMessages[
          DateTime.now().millisecond % _eveningMessages.length];
    }

    // İlerleme bazlı mesaj seç
    String progressBasedMessage;
    if (progress >= 1.0) {
      progressBasedMessage = _achievementMessages[
          DateTime.now().millisecond % _achievementMessages.length];
    } else if (progress >= 0.7) {
      progressBasedMessage = _highProgressMessages[
          DateTime.now().millisecond % _highProgressMessages.length];
    } else if (progress >= 0.3) {
      progressBasedMessage = _midProgressMessages[
          DateTime.now().millisecond % _midProgressMessages.length];
    } else {
      progressBasedMessage = _lowProgressMessages[
          DateTime.now().millisecond % _lowProgressMessages.length];
    }

    // İlerleme yüzdesi ile kişiselleştirilmiş mesajlar
    if (progress >= 1.0) {
      return progressBasedMessage;
    } else if (progress >= 0.5) {
      // Orta-yüksek ilerleme: hem zaman hem ilerleme bilgisi
      return '$timeBasedMessage You\'ve reached ${percentage}% of your goal today, keep going!';
    } else {
      // Düşük ilerleme: motivasyonel mesaj
      return '$timeBasedMessage $progressBasedMessage';
    }
  }

  /// Kısa ve öz mesaj oluştur (bildirim başlığı için)
  String generateShortMessage({
    required double progress,
    required DateTime currentTime,
  }) {
    final hour = currentTime.hour;
    final percentage = (progress * 100).round();

    if (progress >= 1.0) {
      return 'Goal Achieved! 🎉';
    } else if (progress >= 0.6) {
      return 'You\'re at $percentage% - Almost there!';
    } else if (hour >= 6 && hour < 12) {
      return 'Morning Hydration 💧';
    } else if (hour >= 12 && hour < 18) {
      return 'Afternoon Check-in 💧';
    } else {
      return 'Evening Reminder 💧';
    }
  }

  /// Motivasyonel mesajlar (uzun süre su içilmediğinde)
  String generateMotivationalMessage({
    required int hoursSinceLastIntake,
    required DateTime currentTime,
  }) {
    final hour = currentTime.hour;

    if (hoursSinceLastIntake >= 4) {
      return 'It\'s been a while since your last drink. Your body needs hydration - take a moment for yourself 💧';
    } else if (hoursSinceLastIntake >= 2) {
      return 'Time for a hydration break! A glass of water will help you stay focused and energized';
    } else {
      if (hour >= 6 && hour < 12) {
        return 'Morning reminder: Don\'t forget to stay hydrated throughout your busy day';
      } else if (hour >= 12 && hour < 18) {
        return 'Afternoon check-in: Keep your hydration levels up during this busy time';
      } else {
        return 'Evening reminder: Stay hydrated as you wind down';
      }
    }
  }
}

