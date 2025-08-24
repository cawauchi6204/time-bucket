# Task Completion Checklist

## Before Completing Any Task

### Code Quality Checks
1. **Analyze code**: Run `flutter analyze` to check for warnings/errors
2. **Format code**: Run `dart format .` to ensure consistent formatting
3. **Generate code**: Run `dart run build_runner build` if providers or models were added/modified

### Testing
1. **Run tests**: Execute `flutter test` to ensure all tests pass
2. **Test on device**: Use `flutter run` to manually verify functionality works
3. **Check widget test**: Ensure the basic widget test still passes

### Build Verification
1. **Clean build**: Run `flutter clean && flutter pub get` if dependencies changed
2. **Platform builds**: Verify app builds for target platforms:
   - `flutter build apk` for Android
   - `flutter build ios` for iOS
   - `flutter build macos` for macOS
   - `flutter build web` for web

### Database Changes
If database schema was modified:
1. **Check migrations**: Verify database migration logic in `DatabaseHelper`
2. **Test data integrity**: Ensure existing data compatibility
3. **Update version**: Increment database version if schema changed

### State Management
If Riverpod providers were added/modified:
1. **Regenerate code**: Run `dart run build_runner build`
2. **Check provider usage**: Ensure providers are properly consumed in widgets
3. **Test state updates**: Verify state changes work correctly

### Dependencies
If `pubspec.yaml` was modified:
1. **Get dependencies**: Run `flutter pub get`
2. **Check conflicts**: Resolve any version conflicts
3. **Update lockfile**: Ensure `pubspec.lock` is updated

### Final Verification
1. **Hot reload test**: Ensure hot reload works properly during development
2. **Performance check**: Verify no obvious performance regressions
3. **UI consistency**: Check that UI follows existing design patterns