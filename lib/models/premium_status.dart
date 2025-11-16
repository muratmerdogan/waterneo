/// Premium durum modeli
class PremiumStatus {
  final bool isPremium;
  final DateTime? expiryDate;
  final bool isLifetime;

  PremiumStatus({
    required this.isPremium,
    this.expiryDate,
    this.isLifetime = false,
  });

  factory PremiumStatus.free() {
    return PremiumStatus(isPremium: false);
  }

  factory PremiumStatus.premium({DateTime? expiryDate, bool isLifetime = false}) {
    return PremiumStatus(
      isPremium: true,
      expiryDate: expiryDate,
      isLifetime: isLifetime,
    );
  }

  bool get isExpired {
    if (isLifetime) return false;
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  Map<String, dynamic> toJson() {
    return {
      'isPremium': isPremium,
      'expiryDate': expiryDate?.toIso8601String(),
      'isLifetime': isLifetime,
    };
  }

  factory PremiumStatus.fromJson(Map<String, dynamic> json) {
    return PremiumStatus(
      isPremium: json['isPremium'] as bool? ?? false,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      isLifetime: json['isLifetime'] as bool? ?? false,
    );
  }
}

