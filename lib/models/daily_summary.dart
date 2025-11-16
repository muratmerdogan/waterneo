import 'water_intake.dart';

/// Günlük özet modeli
class DailySummary {
  final DateTime date;
  final int totalAmount; // ml cinsinden
  final int targetAmount; // ml cinsinden
  final List<WaterIntake> intakes;

  DailySummary({
    required this.date,
    required this.totalAmount,
    required this.targetAmount,
    required this.intakes,
  });

  /// Hedefi tamamladı mı?
  bool get isTargetReached => totalAmount >= targetAmount;

  /// Tamamlanma yüzdesi (0.0 - 1.0)
  double get completionPercentage {
    if (targetAmount == 0) return 0.0;
    return (totalAmount / targetAmount).clamp(0.0, 1.0);
  }

  /// Tamamlanma yüzdesi (0 - 100)
  int get completionPercentageInt => (completionPercentage * 100).round();

  /// JSON'dan model oluştur
  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      date: DateTime.parse(json['date'] as String),
      totalAmount: json['totalAmount'] as int,
      targetAmount: json['targetAmount'] as int,
      intakes: (json['intakes'] as List<dynamic>)
          .map((e) => WaterIntake.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Model'i JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalAmount': totalAmount,
      'targetAmount': targetAmount,
      'intakes': intakes.map((e) => e.toJson()).toList(),
    };
  }
}

