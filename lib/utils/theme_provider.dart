import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_settings.dart' as models;
import '../services/storage_service.dart';
import '../config/app_theme.dart';
import 'package:flutter/material.dart';

/// Tema modu provider'ı
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
    (ref) => ThemeModeNotifier());

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final storageService = StorageService();
    final settings = await storageService.loadUserSettings();
    state = _themeModeToFlutterThemeMode(settings.themeMode);
  }

  ThemeMode _themeModeToFlutterThemeMode(models.ThemeMode userThemeMode) {
    switch (userThemeMode) {
      case models.ThemeMode.light:
        return ThemeMode.light;
      case models.ThemeMode.dark:
        return ThemeMode.dark;
      case models.ThemeMode.system:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final storageService = StorageService();
    final settings = await storageService.loadUserSettings();
    final userThemeMode = _flutterThemeModeToUserThemeMode(mode);
    await storageService.saveUserSettings(
        settings.copyWith(themeMode: userThemeMode));
  }

  models.ThemeMode _flutterThemeModeToUserThemeMode(ThemeMode flutterMode) {
    switch (flutterMode) {
      case ThemeMode.light:
        return models.ThemeMode.light;
      case ThemeMode.dark:
        return models.ThemeMode.dark;
      case ThemeMode.system:
        return models.ThemeMode.system;
    }
  }
}

/// Tema data provider'ı
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  
  if (themeMode == ThemeMode.dark) {
    return AppTheme.darkTheme;
  } else if (themeMode == ThemeMode.light) {
    return AppTheme.lightTheme;
  } else {
    // System theme
    return brightness == Brightness.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
});

