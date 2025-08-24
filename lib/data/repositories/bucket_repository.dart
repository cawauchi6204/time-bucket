import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import '../models/time_bucket.dart';

class BucketRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<TimeBucket?> createBucket(TimeBucket bucket) async {
    try {
      final db = await _databaseHelper.database;
      await db.insert(
        'time_buckets',
        bucket.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return bucket;
    } catch (e) {
      print('Error creating bucket: $e');
      return null;
    }
  }

  Future<List<TimeBucket>> getUserBuckets(String userId) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'time_buckets',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'order_index ASC, start_age ASC',
      );

      return maps.map((map) => TimeBucket.fromMap(map)).toList();
    } catch (e) {
      print('Error getting user buckets: $e');
      return [];
    }
  }

  Future<TimeBucket?> getBucketById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'time_buckets',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return TimeBucket.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting bucket: $e');
      return null;
    }
  }

  Future<List<TimeBucket>> getActiveBucketsForAge(String userId, int age) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'time_buckets',
        where: 'user_id = ? AND start_age <= ? AND end_age >= ?',
        whereArgs: [userId, age, age],
        orderBy: 'order_index ASC',
      );

      return maps.map((map) => TimeBucket.fromMap(map)).toList();
    } catch (e) {
      print('Error getting active buckets: $e');
      return [];
    }
  }

  Future<bool> updateBucket(TimeBucket bucket) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.update(
        'time_buckets',
        bucket.toMap(),
        where: 'id = ?',
        whereArgs: [bucket.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating bucket: $e');
      return false;
    }
  }

  Future<bool> deleteBucket(String id) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.delete(
        'time_buckets',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting bucket: $e');
      return false;
    }
  }

  Future<int> countUserBuckets(String userId) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM time_buckets WHERE user_id = ?',
        [userId],
      );
      return result.first['count'] as int? ?? 0;
    } catch (e) {
      print('Error counting buckets: $e');
      return 0;
    }
  }

  Future<bool> reorderBuckets(List<String> bucketIds) async {
    try {
      final db = await _databaseHelper.database;
      final batch = db.batch();
      
      for (int i = 0; i < bucketIds.length; i++) {
        batch.update(
          'time_buckets',
          {'order_index': i},
          where: 'id = ?',
          whereArgs: [bucketIds[i]],
        );
      }
      
      await batch.commit();
      return true;
    } catch (e) {
      print('Error reordering buckets: $e');
      return false;
    }
  }
}