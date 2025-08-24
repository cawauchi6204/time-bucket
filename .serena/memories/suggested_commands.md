# Suggested Commands for Life Time Bucket

## Development Commands

### Setup and Dependencies
```bash
# Get dependencies
flutter pub get

# Code generation (for Riverpod and build_runner)
dart run build_runner build

# Watch for changes and rebuild generated code
dart run build_runner watch
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format .

# Check formatting (dry run)
dart format --set-exit-if-changed .
```

### Running the App
```bash
# Run on connected device/emulator
flutter run

# Run in release mode
flutter run --release

# Run on specific platform
flutter run -d macos
flutter run -d chrome
flutter run -d ios
```

### Building
```bash
# Build APK for Android
flutter build apk

# Build iOS
flutter build ios

# Build for macOS
flutter build macos

# Build for web
flutter build web
```

### Database and Debugging
```bash
# Clean build files
flutter clean

# Rebuild after clean
flutter pub get && dart run build_runner build

# Check Flutter environment
flutter doctor

# Show connected devices
flutter devices
```

## Platform-Specific Notes
- **macOS**: Requires Xcode 16.2+
- **Android**: Some licenses may need acceptance with `flutter doctor --android-licenses`
- **Development**: Use `flutter run` for hot reload during development