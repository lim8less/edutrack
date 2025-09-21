// EduTrack app widget tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edutrack_prototype/main.dart';

void main() {
  testWidgets('EduTrack app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EduTrackApp());
    await tester.pump();

    // Verify that the app shows the login screen initially
    expect(find.text('EduTrack'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeast(2)); // Email and password fields
  });
}
