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
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        subscription_type TEXT DEFAULT 'free',
        subscription_expiry TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Time buckets table
    await db.execute('''
      CREATE TABLE time_buckets (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        start_age INTEGER NOT NULL,
        end_age INTEGER NOT NULL,
        description TEXT,
        color TEXT,
        order_index INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Experiences table
    await db.execute('''
      CREATE TABLE experiences (
        id TEXT PRIMARY KEY,
        bucket_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
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
        FOREIGN KEY (bucket_id) REFERENCES time_buckets (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Journal entries table
    await db.execute('''
      CREATE TABLE journal_entries (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        experience_id TEXT,
        bucket_id TEXT,
        content TEXT NOT NULL,
        mood INTEGER DEFAULT 3,
        media_urls TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (experience_id) REFERENCES experiences (id) ON DELETE SET NULL,
        FOREIGN KEY (bucket_id) REFERENCES time_buckets (id) ON DELETE SET NULL
      )
    ''');

    // Life resources table
    await db.execute('''
      CREATE TABLE life_resources (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        health_score INTEGER DEFAULT 50,
        time_score INTEGER DEFAULT 50,
        money_score INTEGER DEFAULT 50,
        recorded_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Memory dividends table
    await db.execute('''
      CREATE TABLE memory_dividends (
        id TEXT PRIMARY KEY,
        experience_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        dividend_type TEXT NOT NULL,
        content_url TEXT,
        description TEXT,
        emotional_value INTEGER DEFAULT 3,
        created_at TEXT NOT NULL,
        FOREIGN KEY (experience_id) REFERENCES experiences (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_buckets_user ON time_buckets(user_id)');
    await db.execute('CREATE INDEX idx_experiences_bucket ON experiences(bucket_id)');
    await db.execute('CREATE INDEX idx_experiences_user ON experiences(user_id)');
    await db.execute('CREATE INDEX idx_journal_user ON journal_entries(user_id)');
    await db.execute('CREATE INDEX idx_resources_user ON life_resources(user_id)');
    await db.execute('CREATE INDEX idx_dividends_experience ON memory_dividends(experience_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    // For now, we'll just recreate the database
    // In production, you'd want to handle data migration properly
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