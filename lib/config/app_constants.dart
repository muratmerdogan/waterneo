/// Uygulama sabitleri - Magic number'ları burada topluyoruz
class AppConstants {
  // Su miktarları (ml)
  static const int quickAdd200 = 200;
  static const int quickAdd250 = 250;
  static const int quickAdd300 = 300;

  // Varsayılan değerler
  static const int defaultDailyGoal = 2500; // ml
  static const int defaultReminderInterval = 90; // dakika
  static const int defaultStartHour = 9;
  static const int defaultEndHour = 22;

  // Kart tasarımı
  static const double cardBorderRadius = 20.0;
  static const double cardElevation = 2.0;

  // Progress indicator
  static const double progressIndicatorSize = 200.0;
  static const double progressStrokeWidth = 12.0;

  // Uyarılar
  static const int warningHoursWithoutIntake = 3; // saat

  // Seri hesaplama
  static const int minStreakDays = 1;

  // Renkler
  static const int primaryColorValue = 0xFF4A90E2;
  static const int backgroundColorLight = 0xFFF5F7FA;
  static const int backgroundColorDark = 0xFF121212;
  static const int cardColorLight = 0xFFFFFFFF;
  static const int cardColorDark = 0xFF1E1E1E;

  // Bildirim ID'leri
  static const int reminderNotificationId = 1000;
  static const int warningNotificationId = 1001;

  // Storage keys
  static const String keyDailyGoal = 'daily_goal';
  static const String keyReminderInterval = 'reminder_interval';
  static const String keyReminderStartHour = 'reminder_start_hour';
  static const String keyReminderEndHour = 'reminder_end_hour';
  static const String keyReminderEnabled = 'reminder_enabled';
  static const String keyReminderMessage = 'reminder_message';
  static const String keyUnit = 'unit';
  static const String keyTheme = 'theme';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyWaterIntakes = 'water_intakes';
  static const String keyStreak = 'streak';
  static const String keyLastIntakeDate = 'last_intake_date';
}

