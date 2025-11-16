import '../config/app_constants.dart';

/// Hatırlatma ayarları modeli
class ReminderSetting {
  final bool enabled;
  final int intervalMinutes; // Hatırlatma aralığı (dakika)
  final int startHour; // Başlangıç saati (0-23)
  final int endHour; // Bitiş saati (0-23)
  final String message; // Bildirim mesajı
  final bool quietHoursEnabled; // Quiet hours aktif mi?
  final int quietHoursStart; // Quiet hours başlangıç (22:00)
  final int quietHoursEnd; // Quiet hours bitiş (08:00)
  final bool soundEnabled; // Ses açık mı?
  final bool vibrationEnabled; // Titreşim açık mı?
  final bool smartNotifications; // Akıllı bildirimler

  ReminderSetting({
    required this.enabled,
    required this.intervalMinutes,
    required this.startHour,
    required this.endHour,
    required this.message,
    this.quietHoursEnabled = true,
    this.quietHoursStart = 22,
    this.quietHoursEnd = 8,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.smartNotifications = true,
  });

  /// Varsayılan ayarlar
  factory ReminderSetting.defaultSettings() {
    return ReminderSetting(
      enabled: true,
      intervalMinutes: AppConstants.defaultReminderInterval,
      startHour: AppConstants.defaultStartHour,
      endHour: AppConstants.defaultEndHour,
      message: 'Take a sip of water ✨',
      quietHoursEnabled: true,
      quietHoursStart: 22,
      quietHoursEnd: 8,
      soundEnabled: true,
      vibrationEnabled: true,
      smartNotifications: true,
    );
  }

  /// JSON'dan model oluştur
  factory ReminderSetting.fromJson(Map<String, dynamic> json) {
    return ReminderSetting(
      enabled: json['enabled'] as bool? ?? true,
      intervalMinutes: json['intervalMinutes'] as int? ??
          AppConstants.defaultReminderInterval,
      startHour: json['startHour'] as int? ?? AppConstants.defaultStartHour,
      endHour: json['endHour'] as int? ?? AppConstants.defaultEndHour,
      message: json['message'] as String? ?? 'Take a sip of water ✨',
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? true,
      quietHoursStart: json['quietHoursStart'] as int? ?? 22,
      quietHoursEnd: json['quietHoursEnd'] as int? ?? 8,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      smartNotifications: json['smartNotifications'] as bool? ?? true,
    );
  }

  /// Model'i JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'intervalMinutes': intervalMinutes,
      'startHour': startHour,
      'endHour': endHour,
      'message': message,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'smartNotifications': smartNotifications,
    };
  }

  /// Kopya oluştur (immutability için)
  ReminderSetting copyWith({
    bool? enabled,
    int? intervalMinutes,
    int? startHour,
    int? endHour,
    String? message,
    bool? quietHoursEnabled,
    int? quietHoursStart,
    int? quietHoursEnd,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? smartNotifications,
  }) {
    return ReminderSetting(
      enabled: enabled ?? this.enabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      message: message ?? this.message,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      smartNotifications: smartNotifications ?? this.smartNotifications,
    );
  }
}

