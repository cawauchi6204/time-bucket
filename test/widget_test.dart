import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:life_time_bucket/main.dart';

void main() {
  testWidgets('TimeBucket app launches', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: TimeBucketApp()));

    // Verify that the app launches
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}