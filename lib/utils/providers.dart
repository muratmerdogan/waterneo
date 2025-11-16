import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_settings.dart';
import '../models/reminder_setting.dart';
import '../models/daily_summary.dart';
import '../services/storage_service.dart';
import '../services/water_intake_service.dart';
import '../services/notification_service.dart';

/// Storage Service Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Water Intake Service Provider
final waterIntakeServiceProvider = Provider<WaterIntakeService>((ref) {
  return WaterIntakeService();
});

/// Notification Service Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// User Settings Provider
final userSettingsProvider =
    StateNotifierProvider<UserSettingsNotifier, UserSettings>((ref) {
  return UserSettingsNotifier(ref.read(storageServiceProvider));
});

class UserSettingsNotifier extends StateNotifier<UserSettings> {
  final StorageService _storageService;

  UserSettingsNotifier(this._storageService)
      : super(UserSettings.defaultSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _storageService.loadUserSettings();
    state = settings;
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    state = newSettings;
    await _storageService.saveUserSettings(newSettings);
  }

  Future<void> updateDailyGoal(int goal) async {
    state = state.copyWith(dailyGoal: goal);
    await _storageService.saveUserSettings(state);
  }

  Future<void> updateUnit(Unit unit) async {
    state = state.copyWith(unit: unit);
    await _storageService.saveUserSettings(state);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingCompleted: true);
    await _storageService.saveUserSettings(state);
  }
}

/// Reminder Settings Provider
final reminderSettingsProvider =
    StateNotifierProvider<ReminderSettingsNotifier, ReminderSetting>((ref) {
  return ReminderSettingsNotifier(ref.read(storageServiceProvider));
});

class ReminderSettingsNotifier extends StateNotifier<ReminderSetting> {
  final StorageService _storageService;

  ReminderSettingsNotifier(this._storageService)
      : super(ReminderSetting.defaultSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _storageService.loadReminderSettings();
    state = settings;
  }

  Future<void> updateSettings(ReminderSetting newSettings) async {
    state = newSettings;
    await _storageService.saveReminderSettings(newSettings);
  }
}

/// Today Summary Provider
final todaySummaryProvider = FutureProvider<DailySummary>((ref) async {
  final waterIntakeService = ref.read(waterIntakeServiceProvider);
  final userSettings = ref.watch(userSettingsProvider);
  return await waterIntakeService.getTodaySummary(userSettings.dailyGoal);
});

/// Streak Provider
final streakProvider = FutureProvider<int>((ref) async {
  final waterIntakeService = ref.read(waterIntakeServiceProvider);
  return await waterIntakeService.calculateAndUpdateStreak();
});

