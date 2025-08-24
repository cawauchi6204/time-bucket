# Life Time Bucket Project Overview

## Purpose
Life Time Bucket is a Flutter-based life planning application that helps users organize their life goals and experiences into age-based "time buckets". The app allows users to plan, track, and manage life experiences across different life stages with features for cost estimation, energy requirements, and progress tracking.

## Core Concepts
- **Time Buckets**: Age-based life phases (e.g., 20-30, 30-40) that contain planned experiences
- **Experiences**: Individual life goals or activities with cost, time, and energy estimates
- **Journal Entries**: Reflective content for tracking progress and thoughts
- **Memory Dividends**: Benefits or insights gained from completed experiences

## Tech Stack
- **Framework**: Flutter 3.22.3+ (Dart SDK 3.4.4+)
- **State Management**: Riverpod with annotations and code generation
- **Database**: SQLite (sqflite)
- **Navigation**: GoRouter
- **UI Components**: Material Design with custom theming using Google Fonts
- **Charts/Visualization**: fl_chart for data visualization
- **Additional Features**: 
  - Image picker for media handling
  - Calendar integration (table_calendar)
  - Animations (Lottie)
  - SVG support
  - Cached network images
  - Permission handling

## Architecture
The app follows a feature-based architecture with clear separation of concerns:

```
lib/
├── core/               # Core utilities, database, services
├── config/             # App configuration (routes, theme)
├── data/               # Data layer (models, repositories, providers)
├── features/           # Feature-specific modules
└── presentation/       # UI layer (screens, widgets)
    ├── screens/        # Full screen components
    └── widgets/        # Reusable UI components
```

## Platform Support
- iOS (Xcode 16.2+)
- macOS 
- Android (SDK 34.0.0)
- Web (Chrome support)
- Windows and Linux directories present