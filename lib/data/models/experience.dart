import 'package:equatable/equatable.dart';

enum ExperienceStatus { planned, inProgress, completed }

class Experience extends Equatable {
  final String id;
  final String bucketId;
  final String title;
  final String? description;
  final double estimatedCost;
  final int energyRequired; // 1-5 scale
  final double timeRequired; // in hours
  final ExperienceStatus status;
  final DateTime? completionDate;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Experience({
    required this.id,
    required this.bucketId,
    required this.title,
    this.description,
    this.estimatedCost = 0,
    this.energyRequired = 3,
    this.timeRequired = 0,
    this.status = ExperienceStatus.planned,
    this.completionDate,
    this.orderIndex = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progressPercentage {
    switch (status) {
      case ExperienceStatus.planned:
        return 0.0;
      case ExperienceStatus.inProgress:
        return 0.5;
      case ExperienceStatus.completed:
        return 1.0;
    }
  }

  String get energyLevel {
    switch (energyRequired) {
      case 1:
        return 'Very Low';
      case 2:
        return 'Low';
      case 3:
        return 'Medium';
      case 4:
        return 'High';
      case 5:
        return 'Very High';
      default:
        return 'Medium';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bucket_id': bucketId,
      'title': title,
      'description': description,
      'estimated_cost': estimatedCost,
      'energy_required': energyRequired,
      'time_required': timeRequired,
      'status': status.name,
      'completion_date': completionDate?.toIso8601String(),
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      id: map['id'] as String,
      bucketId: map['bucket_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      estimatedCost: (map['estimated_cost'] as num?)?.toDouble() ?? 0,
      energyRequired: map['energy_required'] as int? ?? 3,
      timeRequired: (map['time_required'] as num?)?.toDouble() ?? 0,
      status: ExperienceStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ExperienceStatus.planned,
      ),
      completionDate: map['completion_date'] != null
          ? DateTime.parse(map['completion_date'] as String)
          : null,
      orderIndex: map['order_index'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Experience copyWith({
    String? id,
    String? bucketId,
    String? title,
    String? description,
    double? estimatedCost,
    int? energyRequired,
    double? timeRequired,
    ExperienceStatus? status,
    DateTime? completionDate,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Experience(
      id: id ?? this.id,
      bucketId: bucketId ?? this.bucketId,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      energyRequired: energyRequired ?? this.energyRequired,
      timeRequired: timeRequired ?? this.timeRequired,
      status: status ?? this.status,
      completionDate: completionDate ?? this.completionDate,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bucketId,
        title,
        description,
        estimatedCost,
        energyRequired,
        timeRequired,
        status,
        completionDate,
        orderIndex,
        createdAt,
        updatedAt,
      ];
}
