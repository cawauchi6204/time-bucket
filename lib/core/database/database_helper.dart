import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'timebucket.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Time buckets table
    await db.execute('''
      CREATE TABLE time_buckets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        start_age INTEGER NOT NULL,
        end_age INTEGER NOT NULL,
        description TEXT,
        color TEXT,
        icon_path TEXT,
        order_index INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Experiences table
    await db.execute('''
      CREATE TABLE experiences (
        id TEXT PRIMARY KEY,
        bucket_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        estimated_cost REAL DEFAULT 0,
        energy_required INTEGER DEFAULT 3,
        time_required REAL DEFAULT 0,
        status TEXT DEFAULT 'planned',
        completion_date TEXT,
        order_index INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (bucket_id) REFERENCES time_buckets (id) ON DELETE CASCADE
      )
    ''');

    // Journal entries table
    await db.execute('''
      CREATE TABLE journal_entries (
        id TEXT PRIMARY KEY,
        experience_id TEXT,
        bucket_id TEXT,
        content TEXT NOT NULL,
        mood INTEGER DEFAULT 3,
        media_urls TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (experience_id) REFERENCES experiences (id) ON DELETE SET NULL,
        FOREIGN KEY (bucket_id) REFERENCES time_buckets (id) ON DELETE SET NULL
      )
    ''');

    // Life resources table
    await db.execute('''
      CREATE TABLE life_resources (
        id TEXT PRIMARY KEY,
        health_score INTEGER DEFAULT 50,
        time_score INTEGER DEFAULT 50,
        money_score INTEGER DEFAULT 50,
        recorded_at TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Memory dividends table
    await db.execute('''
      CREATE TABLE memory_dividends (
        id TEXT PRIMARY KEY,
        experience_id TEXT NOT NULL,
        dividend_type TEXT NOT NULL,
        content_url TEXT,
        description TEXT,
        emotional_value INTEGER DEFAULT 3,
        created_at TEXT NOT NULL,
        FOREIGN KEY (experience_id) REFERENCES experiences (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute(
        'CREATE INDEX idx_experiences_bucket ON experiences(bucket_id)');
    await db.execute(
        'CREATE INDEX idx_dividends_experience ON memory_dividends(experience_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop all tables and recreate
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS life_resources');
      await db.execute('DROP TABLE IF EXISTS memory_dividends');
      await db.execute('DROP TABLE IF EXISTS journal_entries');
      await db.execute('DROP TABLE IF EXISTS experiences');
      await db.execute('DROP TABLE IF EXISTS time_buckets');

      // Recreate tables
      await _onCreate(db, newVersion);
    }

    if (oldVersion < 3) {
      // Add icon_path column to time_buckets table
      await db.execute('ALTER TABLE time_buckets ADD COLUMN icon_path TEXT');
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }

  // Transaction helper
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction(action);
  }
}
