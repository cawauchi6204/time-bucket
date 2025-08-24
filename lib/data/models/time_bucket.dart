import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TimeBucket extends Equatable {
  final String id;
  final String userId;
  final String name;
  final int startAge;
  final int endAge;
  final String? description;
  final String? color;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TimeBucket({
    required this.id,
    required this.userId,
    required this.name,
    required this.startAge,
    required this.endAge,
    this.description,
    this.color,
    this.orderIndex = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Color get bucketColor {
    if (color == null) return Colors.blue;
    try {
      return Color(int.parse(color!.replaceFirst('#', '0xff')));
    } catch (_) {
      return Colors.blue;
    }
  }

  String get ageRange => '$startAge - $endAge';

  bool isActiveForAge(int age) {
    return age >= startAge && age <= endAge;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'start_age': startAge,
      'end_age': endAge,
      'description': description,
      'color': color,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TimeBucket.fromMap(Map<String, dynamic> map) {
    return TimeBucket(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      startAge: map['start_age'] as int,
      endAge: map['end_age'] as int,
      description: map['description'] as String?,
      color: map['color'] as String?,
      orderIndex: map['order_index'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  TimeBucket copyWith({
    String? id,
    String? userId,
    String? name,
    int? startAge,
    int? endAge,
    String? description,
    String? color,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeBucket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      startAge: startAge ?? this.startAge,
      endAge: endAge ?? this.endAge,
      description: description ?? this.description,
      color: color ?? this.color,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        startAge,
        endAge,
        description,
        color,
        orderIndex,
        createdAt,
        updatedAt,
      ];
}