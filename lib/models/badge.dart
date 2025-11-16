/// Rozet/Badge modeli
class Badge {
  final String id;
  final String title;
  final String description;
  final DateTime unlockedAt;
  final String icon; // Emoji veya icon identifier

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.unlockedAt,
    required this.icon,
  });

  /// JSON'dan model oluştur
  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      icon: json['icon'] as String,
    );
  }

  /// Model'i JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'unlockedAt': unlockedAt.toIso8601String(),
      'icon': icon,
    };
  }
}

