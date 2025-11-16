/// Su içme kaydı modeli
class WaterIntake {
  final DateTime dateTime;
  final int amount; // ml cinsinden

  WaterIntake({
    required this.dateTime,
    required this.amount,
  });

  /// JSON'dan model oluştur
  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    return WaterIntake(
      dateTime: DateTime.parse(json['dateTime'] as String),
      amount: json['amount'] as int,
    );
  }

  /// Model'i JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'amount': amount,
    };
  }

  /// Aynı gün içinde mi kontrolü
  bool isSameDay(DateTime other) {
    return dateTime.year == other.year &&
        dateTime.month == other.month &&
        dateTime.day == other.day;
  }

  /// Bugün mü kontrolü
  bool isToday() {
    final now = DateTime.now();
    return isSameDay(now);
  }
}

