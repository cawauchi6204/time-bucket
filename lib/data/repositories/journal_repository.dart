import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<JournalEntry?> createEntry(JournalEntry entry) async {
    try {
      final db = await _databaseHelper.database;
      await db.insert(
        'journal_entries',
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return entry;
    } catch (e) {
      print('Error creating journal entry: $e');
      return null;
    }
  }

  Future<List<JournalEntry>> getUserEntries(String userId) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'journal_entries',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return maps.map((map) => JournalEntry.fromMap(map)).toList();
    } catch (e) {
      print('Error getting user entries: $e');
      return [];
    }
  }

  Future<List<JournalEntry>> getExperienceEntries(String experienceId) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'journal_entries',
        where: 'experience_id = ?',
        whereArgs: [experienceId],
        orderBy: 'created_at DESC',
      );

      return maps.map((map) => JournalEntry.fromMap(map)).toList();
    } catch (e) {
      print('Error getting experience entries: $e');
      return [];
    }
  }

  Future<List<JournalEntry>> getBucketEntries(String bucketId) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'journal_entries',
        where: 'bucket_id = ?',
        whereArgs: [bucketId],
        orderBy: 'created_at DESC',
      );

      return maps.map((map) => JournalEntry.fromMap(map)).toList();
    } catch (e) {
      print('Error getting bucket entries: $e');
      return [];
    }
  }

  Future<List<JournalEntry>> getEntriesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'journal_entries',
        where: 'user_id = ? AND created_at >= ? AND created_at <= ?',
        whereArgs: [
          userId,
          startDate.toIso8601String(),
          endDate.toIso8601String(),
        ],
        orderBy: 'created_at DESC',
      );

      return maps.map((map) => JournalEntry.fromMap(map)).toList();
    } catch (e) {
      print('Error getting entries by date range: $e');
      return [];
    }
  }

  Future<JournalEntry?> getEntryById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'journal_entries',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return JournalEntry.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting journal entry: $e');
      return null;
    }
  }

  Future<bool> updateEntry(JournalEntry entry) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.update(
        'journal_entries',
        entry.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating journal entry: $e');
      return false;
    }
  }

  Future<bool> deleteEntry(String id) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.delete(
        'journal_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting journal entry: $e');
      return false;
    }
  }

  Future<Map<int, int>> getMoodStats(String userId, int days) async {
    try {
      final db = await _databaseHelper.database;
      final startDate = DateTime.now().subtract(Duration(days: days));
      
      final result = await db.rawQuery('''
        SELECT 
          mood,
          COUNT(*) as count
        FROM journal_entries
        WHERE user_id = ? AND created_at >= ?
        GROUP BY mood
      ''', [userId, startDate.toIso8601String()]);

      final stats = <int, int>{
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
      };

      for (final row in result) {
        final mood = row['mood'] as int;
        final count = row['count'] as int;
        stats[mood] = count;
      }

      return stats;
    } catch (e) {
      print('Error getting mood stats: $e');
      return {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    }
  }

  Future<List<JournalEntry>> searchEntries(String userId, String query) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'journal_entries',
        where: 'user_id = ? AND content LIKE ?',
        whereArgs: [userId, '%$query%'],
        orderBy: 'created_at DESC',
      );

      return maps.map((map) => JournalEntry.fromMap(map)).toList();
    } catch (e) {
      print('Error searching entries: $e');
      return [];
    }
  }
}