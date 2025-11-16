/// Kafein alımı modeli
class CaffeineIntake {
  final DateTime dateTime;
  final CaffeineSource source;
  final double amountMg; // mg cinsinden

  CaffeineIntake({
    required this.dateTime,
    required this.source,
    required this.amountMg,
  });

  /// JSON'dan model oluştur
  factory CaffeineIntake.fromJson(Map<String, dynamic> json) {
    return CaffeineIntake(
      dateTime: DateTime.parse(json['dateTime'] as String),
      source: CaffeineSource.values.firstWhere(
        (e) => e.toString() == 'CaffeineSource.${json['source']}',
        orElse: () => CaffeineSource.coffee,
      ),
      amountMg: (json['amountMg'] as num).toDouble(),
    );
  }

  /// Model'i JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'source': source.toString().split('.').last,
      'amountMg': amountMg,
    };
  }

  /// Bugün mü?
  bool isToday() {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }
}

/// Kafein kaynağı
enum CaffeineSource {
  coffee,
  tea,
  cola,
  energyDrink,
  chocolate,
  other,
}

/// Kafein kaynağı bilgileri
class CaffeineSourceInfo {
  final String name;
  final String emoji;
  final double defaultAmountMg; // Varsayılan miktar (mg)

  const CaffeineSourceInfo({
    required this.name,
    required this.emoji,
    required this.defaultAmountMg,
  });

  static const Map<CaffeineSource, CaffeineSourceInfo> sources = {
    CaffeineSource.coffee: CaffeineSourceInfo(
      name: 'Coffee',
      emoji: '☕',
      defaultAmountMg: 95.0, // 1 cup coffee
    ),
    CaffeineSource.tea: CaffeineSourceInfo(
      name: 'Tea',
      emoji: '🫖',
      defaultAmountMg: 47.0, // 1 cup tea
    ),
    CaffeineSource.cola: CaffeineSourceInfo(
      name: 'Cola',
      emoji: '🥤',
      defaultAmountMg: 34.0, // 1 can cola
    ),
    CaffeineSource.energyDrink: CaffeineSourceInfo(
      name: 'Energy Drink',
      emoji: '⚡',
      defaultAmountMg: 160.0, // 1 can energy drink
    ),
    CaffeineSource.chocolate: CaffeineSourceInfo(
      name: 'Chocolate',
      emoji: '🍫',
      defaultAmountMg: 12.0, // 1 oz dark chocolate
    ),
    CaffeineSource.other: CaffeineSourceInfo(
      name: 'Other',
      emoji: '☕',
      defaultAmountMg: 50.0,
    ),
  };
}

