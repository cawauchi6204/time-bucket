# Database Architecture

## Database: SQLite (via sqflite)
- **File**: `timebucket.db`
- **Location**: Standard databases path
- **Current Version**: 1

## Core Tables

### users
- `id` (TEXT PRIMARY KEY) - UUID
- `email` (TEXT NOT NULL UNIQUE)
- `name` (TEXT NOT NULL)
- `birth_date` (TEXT NOT NULL)
- `subscription_type` (TEXT DEFAULT 'free')
- `subscription_expiry` (TEXT)
- `created_at` (TEXT NOT NULL)
- `updated_at` (TEXT NOT NULL)

### time_buckets
- `id` (TEXT PRIMARY KEY) - UUID
- `user_id` (TEXT NOT NULL) - FK to users
- `name` (TEXT NOT NULL)
- `start_age` (INTEGER NOT NULL)
- `end_age` (INTEGER NOT NULL)
- `description` (TEXT)
- `color` (TEXT) - Hex color code
- `order_index` (INTEGER DEFAULT 0)
- `created_at` (TEXT NOT NULL)
- `updated_at` (TEXT NOT NULL)

### experiences (inferred from model)
- `id` (TEXT PRIMARY KEY) - UUID
- `bucket_id` (TEXT NOT NULL) - FK to time_buckets
- `user_id` (TEXT NOT NULL) - FK to users
- `title` (TEXT NOT NULL)
- `description` (TEXT)
- `estimated_cost` (REAL DEFAULT 0)
- `energy_required` (INTEGER DEFAULT 3) - Scale 1-5
- `time_required` (REAL DEFAULT 0) - Hours
- `status` (TEXT DEFAULT 'planned') - planned/inProgress/completed
- `completion_date` (TEXT) - ISO8601 when completed
- `order_index` (INTEGER DEFAULT 0)
- `created_at` (TEXT NOT NULL)
- `updated_at` (TEXT NOT NULL)

## Data Access Pattern
- **Database Helper**: Singleton pattern in `DatabaseHelper` class
- **Repositories**: Repository pattern for data access abstraction
- **Models**: Immutable data classes with `toMap()`/`fromMap()` serialization

## Key Design Decisions
- **UUIDs**: String-based primary keys for distributed data compatibility
- **Timestamps**: ISO8601 strings for cross-platform compatibility
- **Enums**: Stored as strings for readability and future extensibility
- **Nullable Fields**: Optional data uses nullable columns