import 'package:equatable/equatable.dart';

enum DividendType { photo, video, note }

class MemoryDividend extends Equatable {
  final String id;
  final String experienceId;
  final String userId;
  final DividendType dividendType;
  final String? contentUrl;
  final String? description;
  final int emotionalValue; // 1-5 scale
  final DateTime createdAt;

  const MemoryDividend({
    required this.id,
    required this.experienceId,
    required this.userId,
    required this.dividendType,
    this.contentUrl,
    this.description,
    this.emotionalValue = 3,
    required this.createdAt,
  });

  String get dividendTypeIcon {
    switch (dividendType) {
      case DividendType.photo:
        return '📷';
      case DividendType.video:
        return '🎥';
      case DividendType.note:
        return '📝';
    }
  }

  String get emotionalValueLabel {
    switch (emotionalValue) {
      case 1:
        return 'Low';
      case 2:
        return 'Below Average';
      case 3:
        return 'Average';
      case 4:
        return 'High';
      case 5:
        return 'Very High';
      default:
        return 'Average';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'experience_id': experienceId,
      'user_id': userId,
      'dividend_type': dividendType.name,
      'content_url': contentUrl,
      'description': description,
      'emotional_value': emotionalValue,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MemoryDividend.fromMap(Map<String, dynamic> map) {
    return MemoryDividend(
      id: map['id'] as String,
      experienceId: map['experience_id'] as String,
      userId: map['user_id'] as String,
      dividendType: DividendType.values.firstWhere(
        (e) => e.name == map['dividend_type'],
        orElse: () => DividendType.note,
      ),
      contentUrl: map['content_url'] as String?,
      description: map['description'] as String?,
      emotionalValue: map['emotional_value'] as int? ?? 3,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  MemoryDividend copyWith({
    String? id,
    String? experienceId,
    String? userId,
    DividendType? dividendType,
    String? contentUrl,
    String? description,
    int? emotionalValue,
    DateTime? createdAt,
  }) {
    return MemoryDividend(
      id: id ?? this.id,
      experienceId: experienceId ?? this.experienceId,
      userId: userId ?? this.userId,
      dividendType: dividendType ?? this.dividendType,
      contentUrl: contentUrl ?? this.contentUrl,
      description: description ?? this.description,
      emotionalValue: emotionalValue ?? this.emotionalValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        experienceId,
        userId,
        dividendType,
        contentUrl,
        description,
        emotionalValue,
        createdAt,
      ];
}
