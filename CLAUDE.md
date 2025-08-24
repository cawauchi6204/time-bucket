# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Life Time Bucket is a Flutter application for life planning and goal tracking. Users organize life experiences into age-based "time buckets" with cost, time, and energy estimates. The app features time bucket management, experience tracking, journaling, and progress visualization.

## Architecture

Feature-based architecture with clear separation:
- `lib/core/` - Database, services, utilities
- `lib/data/` - Models, repositories, providers
- `lib/features/` - Feature-specific modules  
- `lib/presentation/` - Screens and reusable widgets
- `lib/config/` - App configuration (routes, theme)

## Tech Stack

- **Flutter** 3.22.3+ with Dart SDK 3.4.4+
- **State Management**: Riverpod with code generation
- **Database**: SQLite (sqflite) with repository pattern
- **Navigation**: GoRouter
- **UI**: Material Design with Google Fonts, Lottie animations
- **Code Generation**: build_runner for Riverpod providers

## Essential Commands

### Development Setup
```bash
flutter pub get                              # Install dependencies
dart run build_runner build                 # Generate Riverpod code
dart run build_runner watch                 # Watch for changes
```

### Code Quality
```bash
flutter analyze                             # Static analysis
dart format .                              # Format code
flutter test                               # Run tests
```

### Running & Building
```bash
flutter run                                 # Development with hot reload
flutter run --release                      # Release mode
flutter build apk                          # Android build
flutter build ios                          # iOS build
flutter build macos                        # macOS build
```

## Code Conventions

- **Files**: snake_case (`time_bucket.dart`)
- **Classes**: PascalCase (`TimeBucket`) 
- **Variables**: camelCase
- **Database tables**: snake_case (`time_buckets`)
- **Models**: Immutable with Equatable, `toMap()`/`fromMap()` methods
- **State**: Riverpod providers with annotations
- **Widgets**: ConsumerWidget for state access

## Database Schema

SQLite database with core tables:
- `users` - User profiles with subscription info
- `time_buckets` - Age-based life phases (start_age, end_age)
- `experiences` - Goals/activities with cost, energy, time estimates
- Primary keys are String UUIDs, timestamps as ISO8601 strings

## Task Completion Checklist

Always run before finishing tasks:
1. `flutter analyze` - Check for warnings/errors
2. `dart format .` - Ensure consistent formatting  
3. `dart run build_runner build` - Regenerate code if providers changed
4. `flutter test` - Verify tests pass
5. `flutter run` - Manual verification on device

## Development Notes

- Run code generation after adding/modifying Riverpod providers
- Database uses repository pattern for data access
- Hot reload available during development with `flutter run`
- Platform support: iOS, Android, macOS, Web