// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mozhi_frontend/main.dart';

void main() {
  testWidgets('Mozhii app smoke test - Splash Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MozhiiApp());

    // Verify that the app initializes and shows the splash screen
    await tester.pumpAndSettle();

    // The app should show the splash screen with "Get Started" button
    expect(find.text('Get Started'), findsOneWidget);
    
    // Verify the arrow icon is present
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });

  testWidgets('Navigate from Splash to Home', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MozhiiApp());
    await tester.pumpAndSettle();

    // Find and tap the "Get Started" button
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // After tapping, we should be on the home screen
    // You can add specific home screen checks here based on your HomeScreen widget
    // For example:
    // expect(find.text('Home'), findsOneWidget);
    // Or check for specific widgets that exist in HomeScreen
  });
}