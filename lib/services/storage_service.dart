import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/water_intake.dart';
import '../models/user_settings.dart';
import '../models/reminder_setting.dart';
import '../config/app_constants.dart';

/// Local storage servisi - SharedPreferences kullanarak veri saklama
class StorageService {
  static const String _keyWaterIntakes = AppConstants.keyWaterIntakes;
  static const String _keyUserSettings = 'user_settings';
  static const String _keyReminderSettings = 'reminder_settings';
  static const String _keyStreak = AppConstants.keyStreak;
  static const String _keyLastIntakeDate = AppConstants.keyLastIntakeDate;

  /// Su içme kayıtlarını kaydet
  Future<void> saveWaterIntakes(List<WaterIntake> intakes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = intakes.map((e) => e.toJson()).toList();
    await prefs.setString(_keyWaterIntakes, jsonEncode(jsonList));
  }

  /// Su içme kayıtlarını yükle
  Future<List<WaterIntake>> loadWaterIntakes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyWaterIntakes);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => WaterIntake.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Kullanıcı ayarlarını kaydet
  Future<void> saveUserSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserSettings, jsonEncode(settings.toJson()));
  }

  /// Kullanıcı ayarlarını yükle
  Future<UserSettings> loadUserSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyUserSettings);
    if (jsonString == null) {
      return UserSettings.defaultSettings();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserSettings.fromJson(json);
    } catch (e) {
      return UserSettings.defaultSettings();
    }
  }

  /// Hatırlatma ayarlarını kaydet
  Future<void> saveReminderSettings(ReminderSetting settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _keyReminderSettings, jsonEncode(settings.toJson()));
  }

  /// Hatırlatma ayarlarını yükle
  Future<ReminderSetting> loadReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyReminderSettings);
    if (jsonString == null) {
      return ReminderSetting.defaultSettings();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ReminderSetting.fromJson(json);
    } catch (e) {
      return ReminderSetting.defaultSettings();
    }
  }

  /// Seri (streak) kaydet
  Future<void> saveStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyStreak, streak);
  }

  /// Seri (streak) yükle
  Future<int> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyStreak) ?? 0;
  }

  /// Son içme tarihini kaydet
  Future<void> saveLastIntakeDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastIntakeDate, date.toIso8601String());
  }

  /// Son içme tarihini yükle
  Future<DateTime?> loadLastIntakeDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_keyLastIntakeDate);
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Tüm verileri temizle (test için)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Generic JSON kaydet
  Future<void> saveJson(String key, dynamic json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(json));
  }

  /// Generic JSON yükle
  Future<dynamic> loadJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }
}

