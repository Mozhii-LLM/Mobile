// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:mozhi_frontend/main.dart';

void main() {
  testWidgets('Mozhii app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MozhiiApp());

    // Verify that the app initializes and shows the home screen
    await tester.pumpAndSettle();

    // The app should show the home screen with logo
    expect(find.text('Mozhii'), findsOneWidget);
  });
}
