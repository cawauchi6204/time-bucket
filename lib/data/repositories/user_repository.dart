import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import '../models/user.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<User?> createUser(User user) async {
    try {
      final db = await _databaseHelper.database;
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return user;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  Future<bool> updateSubscription(
    String userId,
    SubscriptionType type,
    DateTime? expiry,
  ) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.update(
        'users',
        {
          'subscription_type': type.name,
          'subscription_expiry': expiry?.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );
      return result > 0;
    } catch (e) {
      print('Error updating subscription: $e');
      return false;
    }
  }
}