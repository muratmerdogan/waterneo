import '../models/caffeine_intake.dart';
import 'storage_service.dart';

/// Kafein takip servisi
class CaffeineService {
  final StorageService _storageService = StorageService();
  static const String _storageKey = 'caffeine_intakes';
  static const double _dailyLimitMg = 400.0; // FDA önerisi: 400mg/gün

  /// Kafein alımı ekle
  Future<void> addCaffeineIntake(CaffeineIntake intake) async {
    final intakes = await loadCaffeineIntakes();
    intakes.add(intake);
    await _saveCaffeineIntakes(intakes);
  }

  /// Kafein alımını sil
  Future<void> deleteCaffeineIntake(CaffeineIntake intake) async {
    final intakes = await loadCaffeineIntakes();
    intakes.removeWhere((e) =>
        e.dateTime == intake.dateTime &&
        e.source == intake.source &&
        e.amountMg == intake.amountMg);
    await _saveCaffeineIntakes(intakes);
  }

  /// Bugünkü tüm kafein alımlarını getir
  Future<List<CaffeineIntake>> getTodayIntakes() async {
    final allIntakes = await loadCaffeineIntakes();
    return allIntakes.where((intake) => intake.isToday()).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /// Bugünkü toplam kafein miktarını hesapla
  Future<double> getTodayTotalMg() async {
    final todayIntakes = await getTodayIntakes();
    return todayIntakes.fold<double>(0.0, (sum, intake) => sum + intake.amountMg);
  }

  /// Günlük limit yüzdesi
  Future<double> getDailyLimitPercentage() async {
    final total = await getTodayTotalMg();
    return (total / _dailyLimitMg).clamp(0.0, 1.0);
  }

  /// Son N günün özetlerini getir
  Future<List<Map<String, dynamic>>> getLastNDaysSummaries(int days) async {
    final summaries = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final intakes = await _getIntakesForDate(date);
      final total = intakes.fold<double>(0.0, (sum, intake) => sum + intake.amountMg);

      summaries.add({
        'date': date,
        'totalMg': total,
        'intakes': intakes,
      });
    }

    return summaries.reversed.toList();
  }

  /// Belirli bir günün alımlarını getir
  Future<List<CaffeineIntake>> _getIntakesForDate(DateTime date) async {
    final allIntakes = await loadCaffeineIntakes();
    return allIntakes
        .where((intake) =>
            intake.dateTime.year == date.year &&
            intake.dateTime.month == date.month &&
            intake.dateTime.day == date.day)
        .toList();
  }

  /// Tüm kafein alımlarını yükle
  Future<List<CaffeineIntake>> loadCaffeineIntakes() async {
    final json = await _storageService.loadJson(_storageKey);
    if (json == null) return [];

    final List<dynamic> data = json as List<dynamic>;
    return data
        .map((e) => CaffeineIntake.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Kafein alımlarını kaydet
  Future<void> _saveCaffeineIntakes(List<CaffeineIntake> intakes) async {
    final json = intakes.map((e) => e.toJson()).toList();
    await _storageService.saveJson(_storageKey, json);
  }

  /// Günlük limit
  static double get dailyLimitMg => _dailyLimitMg;
}

