import 'dart:convert';
import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  final String id;
  final String userId;
  final String? experienceId;
  final String? bucketId;
  final String content;
  final int mood; // 1-5 scale
  final List<String> mediaUrls;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JournalEntry({
    required this.id,
    required this.userId,
    this.experienceId,
    this.bucketId,
    required this.content,
    this.mood = 3,
    this.mediaUrls = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  String get moodEmoji {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  String get moodText {
    switch (mood) {
      case 1:
        return 'Very Sad';
      case 2:
        return 'Sad';
      case 3:
        return 'Neutral';
      case 4:
        return 'Happy';
      case 5:
        return 'Very Happy';
      default:
        return 'Neutral';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'experience_id': experienceId,
      'bucket_id': bucketId,
      'content': content,
      'mood': mood,
      'media_urls': jsonEncode(mediaUrls),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      experienceId: map['experience_id'] as String?,
      bucketId: map['bucket_id'] as String?,
      content: map['content'] as String,
      mood: map['mood'] as int? ?? 3,
      mediaUrls: map['media_urls'] != null
          ? List<String>.from(jsonDecode(map['media_urls'] as String))
          : [],
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  JournalEntry copyWith({
    String? id,
    String? userId,
    String? experienceId,
    String? bucketId,
    String? content,
    int? mood,
    List<String>? mediaUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      experienceId: experienceId ?? this.experienceId,
      bucketId: bucketId ?? this.bucketId,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        experienceId,
        bucketId,
        content,
        mood,
        mediaUrls,
        createdAt,
        updatedAt,
      ];
}
