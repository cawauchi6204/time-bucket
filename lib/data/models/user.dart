import 'package:equatable/equatable.dart';

enum SubscriptionType { free, premium }

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final DateTime birthDate;
  final SubscriptionType subscriptionType;
  final DateTime? subscriptionExpiry;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.birthDate,
    this.subscriptionType = SubscriptionType.free,
    this.subscriptionExpiry,
    required this.createdAt,
    required this.updatedAt,
  });

  int get currentAge {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  bool get isPremium {
    if (subscriptionType == SubscriptionType.free) return false;
    if (subscriptionExpiry == null) return false;
    return subscriptionExpiry!.isAfter(DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'birth_date': birthDate.toIso8601String(),
      'subscription_type': subscriptionType.name,
      'subscription_expiry': subscriptionExpiry?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      birthDate: DateTime.parse(map['birth_date'] as String),
      subscriptionType: SubscriptionType.values.firstWhere(
        (e) => e.name == map['subscription_type'],
        orElse: () => SubscriptionType.free,
      ),
      subscriptionExpiry: map['subscription_expiry'] != null
          ? DateTime.parse(map['subscription_expiry'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? birthDate,
    SubscriptionType? subscriptionType,
    DateTime? subscriptionExpiry,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        birthDate,
        subscriptionType,
        subscriptionExpiry,
        createdAt,
        updatedAt,
      ];
}