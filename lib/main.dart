import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme.dart';
import 'config/routes.dart';

void main() {
  // Enable layout debugging in debug mode
  debugPaintSizeEnabled = false; // Set to true for visual debugging
  
  runApp(const ProviderScope(child: TimeBucketApp()));
}

class TimeBucketApp extends ConsumerWidget {
  const TimeBucketApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'TimeBucket - Life Planning',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}