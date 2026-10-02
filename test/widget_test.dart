// Basic widget test for the CCMS app.

import 'package:flutter_test/flutter_test.dart';

import 'package:ccms/main.dart';

void main() {
  testWidgets('CCMS app smoke test', (WidgetTester tester) async {
    // Build the CCMS app and trigger a frame.
    await tester.pumpWidget(const CCMSApp());

    // Verify the splash screen shows the app name.
    expect(find.text('CCMS'), findsOneWidget);
  });
}
