import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import '../models/experience.dart';

class ExperienceRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Experience?> createExperience(Experience experience) async {
    try {
      final db = await _databaseHelper.database;
      await db.insert(
        'experiences',
        experience.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return experience;
    } catch (e) {
      print('Error creating experience: $e');
      return null;
    }
  }

  Future<List<Experience>> getBucketExperiences(String bucketId) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'experiences',
        where: 'bucket_id = ?',
        whereArgs: [bucketId],
        orderBy: 'order_index ASC, created_at DESC',
      );

      return maps.map((map) => Experience.fromMap(map)).toList();
    } catch (e) {
      print('Error getting bucket experiences: $e');
      return [];
    }
  }

  Future<List<Experience>> getUserExperiences(String userId) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'experiences',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return maps.map((map) => Experience.fromMap(map)).toList();
    } catch (e) {
      print('Error getting user experiences: $e');
      return [];
    }
  }

  Future<List<Experience>> getExperiencesByStatus(
    String userId,
    ExperienceStatus status,
  ) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'experiences',
        where: 'user_id = ? AND status = ?',
        whereArgs: [userId, status.name],
        orderBy: 'updated_at DESC',
      );

      return maps.map((map) => Experience.fromMap(map)).toList();
    } catch (e) {
      print('Error getting experiences by status: $e');
      return [];
    }
  }

  Future<Experience?> getExperienceById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'experiences',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Experience.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting experience: $e');
      return null;
    }
  }

  Future<bool> updateExperience(Experience experience) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.update(
        'experiences',
        experience.toMap(),
        where: 'id = ?',
        whereArgs: [experience.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating experience: $e');
      return false;
    }
  }

  Future<bool> updateExperienceStatus(
    String id,
    ExperienceStatus status,
    DateTime? completionDate,
  ) async {
    try {
      final db = await _databaseHelper.database;
      final Map<String, dynamic> updates = {
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (status == ExperienceStatus.completed && completionDate != null) {
        updates['completion_date'] = completionDate.toIso8601String();
      }
      
      final result = await db.update(
        'experiences',
        updates,
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating experience status: $e');
      return false;
    }
  }

  Future<bool> deleteExperience(String id) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.delete(
        'experiences',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting experience: $e');
      return false;
    }
  }

  Future<Map<String, int>> getExperienceStats(String userId) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery('''
        SELECT 
          status,
          COUNT(*) as count
        FROM experiences
        WHERE user_id = ?
        GROUP BY status
      ''', [userId]);

      final stats = <String, int>{
        'planned': 0,
        'in_progress': 0,
        'completed': 0,
      };

      for (final row in result) {
        final status = row['status'] as String;
        final count = row['count'] as int;
        stats[status] = count;
      }

      return stats;
    } catch (e) {
      print('Error getting experience stats: $e');
      return {
        'planned': 0,
        'in_progress': 0,
        'completed': 0,
      };
    }
  }

  Future<double> getTotalEstimatedCost(String bucketId) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery('''
        SELECT SUM(estimated_cost) as total
        FROM experiences
        WHERE bucket_id = ?
      ''', [bucketId]);

      return result.first['total'] as double? ?? 0.0;
    } catch (e) {
      print('Error calculating total cost: $e');
      return 0.0;
    }
  }
}