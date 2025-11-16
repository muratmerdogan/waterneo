import '../config/app_constants.dart';

/// Kullanıcı ayarları modeli
enum Unit { ml, oz }

enum ThemeMode { light, dark, system }

enum Gender { male, female, other }

enum ActivityLevel { low, normal, intense }

/// Kullanıcı ayarları
class UserSettings {
  final int dailyGoal; // ml cinsinden
  final Unit unit;
  final ThemeMode themeMode;
  final bool onboardingCompleted;
  final Gender? gender;
  final double? weight; // kg
  final int? wakeUpHour; // 0-23
  final int? sleepHour; // 0-23
  final ActivityLevel? activityLevel;

  UserSettings({
    required this.dailyGoal,
    required this.unit,
    required this.themeMode,
    required this.onboardingCompleted,
    this.gender,
    this.weight,
    this.wakeUpHour,
    this.sleepHour,
    this.activityLevel,
  });

  /// Varsayılan ayarlar
  factory UserSettings.defaultSettings() {
    return UserSettings(
      dailyGoal: AppConstants.defaultDailyGoal,
      unit: Unit.ml,
      themeMode: ThemeMode.system,
      onboardingCompleted: false,
    );
  }

  /// JSON'dan model oluştur
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    Gender? gender;
    if (json['gender'] != null) {
      try {
        gender = Gender.values.firstWhere(
          (e) => e.toString() == 'Gender.${json['gender']}',
        );
      } catch (_) {
        gender = null;
      }
    }

    ActivityLevel? activityLevel;
    if (json['activityLevel'] != null) {
      try {
        activityLevel = ActivityLevel.values.firstWhere(
          (e) => e.toString() == 'ActivityLevel.${json['activityLevel']}',
        );
      } catch (_) {
        activityLevel = null;
      }
    }

    return UserSettings(
      dailyGoal: json['dailyGoal'] as int? ?? AppConstants.defaultDailyGoal,
      unit: Unit.values.firstWhere(
        (e) => e.toString() == 'Unit.${json['unit']}',
        orElse: () => Unit.ml,
      ),
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.${json['themeMode']}',
        orElse: () => ThemeMode.system,
      ),
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      gender: gender,
      weight: json['weight'] as double?,
      wakeUpHour: json['wakeUpHour'] as int?,
      sleepHour: json['sleepHour'] as int?,
      activityLevel: activityLevel,
    );
  }

  /// Model'i JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'dailyGoal': dailyGoal,
      'unit': unit.toString().split('.').last,
      'themeMode': themeMode.toString().split('.').last,
      'onboardingCompleted': onboardingCompleted,
      'gender': gender?.toString().split('.').last,
      'weight': weight,
      'wakeUpHour': wakeUpHour,
      'sleepHour': sleepHour,
      'activityLevel': activityLevel?.toString().split('.').last,
    };
  }

  /// Kopya oluştur
  UserSettings copyWith({
    int? dailyGoal,
    Unit? unit,
    ThemeMode? themeMode,
    bool? onboardingCompleted,
    Gender? gender,
    double? weight,
    int? wakeUpHour,
    int? sleepHour,
    ActivityLevel? activityLevel,
  }) {
    return UserSettings(
      dailyGoal: dailyGoal ?? this.dailyGoal,
      unit: unit ?? this.unit,
      themeMode: themeMode ?? this.themeMode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      wakeUpHour: wakeUpHour ?? this.wakeUpHour,
      sleepHour: sleepHour ?? this.sleepHour,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  /// Günlük su hedefini hesapla (weight * 0.03 + activityFactor)
  static int calculateDailyGoal({
    required double weight,
    required ActivityLevel activityLevel,
    double temperatureFactor = 0.0, // Ekstra faktör (sıcaklık vb.)
  }) {
    final baseAmount = weight * 0.03; // kg başına 30ml
    double activityFactor = 0.0;
    
    switch (activityLevel) {
      case ActivityLevel.low:
        activityFactor = 200.0; // 200ml ekstra
        break;
      case ActivityLevel.normal:
        activityFactor = 500.0; // 500ml ekstra
        break;
      case ActivityLevel.intense:
        activityFactor = 800.0; // 800ml ekstra
        break;
    }
    
    final total = (baseAmount * 1000) + activityFactor + temperatureFactor;
    return total.round();
  }

  /// Birim dönüşümü: ml'yi seçili birime çevir
  double convertToUnit(int ml) {
    if (unit == Unit.oz) {
      return ml / 29.5735; // 1 oz = 29.5735 ml
    }
    return ml.toDouble();
  }

  /// Birim etiketi
  String get unitLabel {
    return unit == Unit.oz ? 'oz' : 'ml';
  }
}

