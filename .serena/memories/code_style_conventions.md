# Code Style and Conventions

## Code Analysis
- Uses `package:flutter_lints/flutter.yaml` for standard Flutter linting
- Analysis configuration in `analysis_options.yaml`
- Follows standard Flutter/Dart conventions

## Naming Conventions
- **Files**: snake_case (e.g., `time_bucket.dart`, `database_helper.dart`)
- **Classes**: PascalCase (e.g., `TimeBucket`, `DatabaseHelper`)
- **Variables/Methods**: camelCase
- **Constants**: SCREAMING_SNAKE_CASE or camelCase for private
- **Directories**: snake_case

## Architecture Patterns
- **Models**: Use Equatable for value equality, immutable data classes
- **Database**: Maps with `toMap()` and `fromMap()` factory constructors
- **State Management**: Riverpod providers with annotations
- **Widgets**: ConsumerWidget for state access, StatelessWidget for static UI

## File Structure
- **Models**: Located in `lib/data/models/`
- **Repositories**: Located in `lib/data/repositories/`
- **Screens**: Located in `lib/presentation/screens/[feature]/`
- **Widgets**: Located in `lib/presentation/widgets/`
- **Core utilities**: Located in `lib/core/`

## Code Generation
- Uses `riverpod_generator` and `riverpod_annotation` for provider generation
- Run `dart run build_runner build` after adding new providers
- Generated files have `.g.dart` extension

## Database Conventions
- Table names: snake_case (e.g., `time_buckets`, `journal_entries`)
- Column names: snake_case (e.g., `user_id`, `created_at`)
- Primary keys: String UUIDs
- Timestamps: ISO8601 strings stored as TEXT

## Widget Organization
- Screens are full-page widgets in feature directories
- Common widgets are in `lib/presentation/widgets/common/`
- Feature-specific widgets in `lib/presentation/widgets/[feature]/`

## Import Organization
- Flutter imports first
- Third-party package imports
- Internal imports (relative paths)
- Separate groups with blank lines

## Error Handling
- Use try-catch blocks for database operations
- Provide fallback values in model constructors
- Use null safety features consistently