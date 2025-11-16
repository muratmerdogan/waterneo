import '../models/water_intake.dart';
import '../models/daily_summary.dart';
import '../services/storage_service.dart';
import '../config/app_constants.dart';

/// Su içme kayıtları servisi
class WaterIntakeService {
  final StorageService _storageService = StorageService();

  /// Su içme kaydı ekle
  Future<void> addWaterIntake(int amount) async {
    final intakes = await _storageService.loadWaterIntakes();
    final newIntake = WaterIntake(
      dateTime: DateTime.now(),
      amount: amount,
    );
    intakes.add(newIntake);
    await _storageService.saveWaterIntakes(intakes);
  }

  /// Su içme kaydını sil
  Future<void> deleteWaterIntake(WaterIntake intake) async {
    final intakes = await _storageService.loadWaterIntakes();
    intakes.removeWhere((e) =>
        e.dateTime == intake.dateTime && e.amount == intake.amount);
    await _storageService.saveWaterIntakes(intakes);
  }

  /// Bugünkü tüm kayıtları getir
  Future<List<WaterIntake>> getTodayIntakes() async {
    final allIntakes = await _storageService.loadWaterIntakes();
    return allIntakes.where((intake) => intake.isToday()).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /// Belirli bir günün kayıtlarını getir
  Future<List<WaterIntake>> getIntakesForDate(DateTime date) async {
    final allIntakes = await _storageService.loadWaterIntakes();
    return allIntakes
        .where((intake) =>
            intake.dateTime.year == date.year &&
            intake.dateTime.month == date.month &&
            intake.dateTime.day == date.day)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /// Bugünkü toplam miktarı hesapla
  Future<int> getTodayTotalAmount() async {
    final todayIntakes = await getTodayIntakes();
    return todayIntakes.fold<int>(0, (sum, intake) => sum + intake.amount);
  }

  /// Belirli bir günün toplam miktarını hesapla
  Future<int> getTotalAmountForDate(DateTime date) async {
    final intakes = await getIntakesForDate(date);
    return intakes.fold<int>(0, (sum, intake) => sum + intake.amount);
  }

  /// Bugünkü özeti getir
  Future<DailySummary> getTodaySummary(int targetAmount) async {
    final todayIntakes = await getTodayIntakes();
    final totalAmount = todayIntakes.fold<int>(0, (sum, intake) => sum + intake.amount);
    return DailySummary(
      date: DateTime.now(),
      totalAmount: totalAmount,
      targetAmount: targetAmount,
      intakes: todayIntakes,
    );
  }

  /// Belirli bir günün özetini getir
  Future<DailySummary> getSummaryForDate(
      DateTime date, int targetAmount) async {
    final intakes = await getIntakesForDate(date);
    final totalAmount = intakes.fold<int>(0, (sum, intake) => sum + intake.amount);
    return DailySummary(
      date: date,
      totalAmount: totalAmount,
      targetAmount: targetAmount,
      intakes: intakes,
    );
  }

  /// Son N günün özetlerini getir
  Future<List<DailySummary>> getLastNDaysSummaries(
      int days, int targetAmount) async {
    final summaries = <DailySummary>[];
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final summary = await getSummaryForDate(date, targetAmount);
      summaries.add(summary);
    }

    return summaries.reversed.toList(); // En eski tarih önce
  }

  /// Seri (streak) hesapla ve güncelle
  Future<int> calculateAndUpdateStreak() async {
    final currentStreak = await _storageService.loadStreak();
    final lastIntakeDate = await _storageService.loadLastIntakeDate();
    final now = DateTime.now();

    // Bugünkü özeti al
    final userSettings = await _storageService.loadUserSettings();
    final todaySummary = await getTodaySummary(userSettings.dailyGoal);

    final today = DateTime(now.year, now.month, now.day);
    
    if (todaySummary.isTargetReached) {
      // Hedef tamamlandı
      if (lastIntakeDate == null) {
        // İlk gün
        await _storageService.saveStreak(1);
        await _storageService.saveLastIntakeDate(today);
        return 1;
      }

      final lastDate = DateTime(
        lastIntakeDate.year,
        lastIntakeDate.month,
        lastIntakeDate.day,
      );

      if (lastDate.isAtSameMomentAs(today)) {
        // Aynı gün, streak değişmez
        return currentStreak;
      } else if (lastDate
          .add(const Duration(days: 1))
          .isAtSameMomentAs(today)) {
        // Ardışık gün, streak artar
        final newStreak = currentStreak + 1;
        await _storageService.saveStreak(newStreak);
        await _storageService.saveLastIntakeDate(today);
        return newStreak;
      } else {
        // Seri kırıldı, yeniden başla
        await _storageService.saveStreak(1);
        await _storageService.saveLastIntakeDate(today);
        return 1;
      }
    }

    // Hedef tamamlanmadı, streak değişmez
    return currentStreak;
  }

  /// Son içme zamanını kontrol et (uyarı için)
  Future<bool> shouldShowWarning() async {
    final todayIntakes = await getTodayIntakes();
    if (todayIntakes.isEmpty) {
      // Bugün hiç su içilmemiş
      final now = DateTime.now();
      final morning = DateTime(now.year, now.month, now.day, 9, 0);
      return now.difference(morning).inHours >=
          AppConstants.warningHoursWithoutIntake;
    }

    final lastIntake = todayIntakes.first;
    final hoursSinceLastIntake =
        DateTime.now().difference(lastIntake.dateTime).inHours;
    return hoursSinceLastIntake >= AppConstants.warningHoursWithoutIntake;
  }
}

