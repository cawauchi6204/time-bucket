import 'package:equatable/equatable.dart';

class LifeResource extends Equatable {
  final String id;
  final String userId;
  final int healthScore; // 0-100
  final int timeScore; // 0-100
  final int moneyScore; // 0-100
  final DateTime recordedAt;
  final DateTime createdAt;

  const LifeResource({
    required this.id,
    required this.userId,
    this.healthScore = 50,
    this.timeScore = 50,
    this.moneyScore = 50,
    required this.recordedAt,
    required this.createdAt,
  });

  double get averageScore => (healthScore + timeScore + moneyScore) / 3;

  String getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    if (score >= 20) return 'Poor';
    return 'Critical';
  }

  String get healthLabel => getScoreLabel(healthScore);
  String get timeLabel => getScoreLabel(timeScore);
  String get moneyLabel => getScoreLabel(moneyScore);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'health_score': healthScore,
      'time_score': timeScore,
      'money_score': moneyScore,
      'recorded_at': recordedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory LifeResource.fromMap(Map<String, dynamic> map) {
    return LifeResource(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      healthScore: map['health_score'] as int? ?? 50,
      timeScore: map['time_score'] as int? ?? 50,
      moneyScore: map['money_score'] as int? ?? 50,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  LifeResource copyWith({
    String? id,
    String? userId,
    int? healthScore,
    int? timeScore,
    int? moneyScore,
    DateTime? recordedAt,
    DateTime? createdAt,
  }) {
    return LifeResource(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      healthScore: healthScore ?? this.healthScore,
      timeScore: timeScore ?? this.timeScore,
      moneyScore: moneyScore ?? this.moneyScore,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object> get props => [
        id,
        userId,
        healthScore,
        timeScore,
        moneyScore,
        recordedAt,
        createdAt,
      ];
}
