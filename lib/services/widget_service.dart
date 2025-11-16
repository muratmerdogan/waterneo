import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';
import 'water_intake_service.dart';

/// Widget Service - iOS Widget'lar için veri sağlayıcı
class WidgetService {
  final StorageService _storageService = StorageService();
  final WaterIntakeService _waterIntakeService = WaterIntakeService();

  /// Widget için bugünkü özeti getir
  Future<Map<String, dynamic>> getTodaySummaryForWidget() async {
    try {
      final userSettings = await _storageService.loadUserSettings();
      final todaySummary = await _waterIntakeService.getTodaySummary(
        userSettings.dailyGoal,
      );

      return {
        'progress': todaySummary.completionPercentage,
        'totalAmount': todaySummary.totalAmount,
        'targetAmount': todaySummary.targetAmount,
        'unitLabel': userSettings.unitLabel,
        'isTargetReached': todaySummary.isTargetReached,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'progress': 0.0,
        'totalAmount': 0,
        'targetAmount': 2500,
        'unitLabel': 'ml',
        'isTargetReached': false,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Widget verilerini App Group'a kaydet (iOS Widgets için)
  Future<void> saveWidgetData() async {
    final summary = await getTodaySummaryForWidget();
    
    // App Group kullanarak widget'a veri gönder
    // iOS'ta UserDefaults ile App Group paylaşımı yapılır
    // Bu Flutter tarafında hazırlık, native tarafında implement edilmeli
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('widget_data', jsonEncode(summary));
  }
}

