import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ccms/main.dart';
import 'package:ccms/providers/auth_provider.dart';
import 'package:ccms/providers/complaint_provider.dart';
import 'package:ccms/utils/constants.dart';

void main() {
  testWidgets('CCMS Smoke Test - App renders title on Splash Screen', (WidgetTester tester) async {
    // Build our app with AuthProvider and ComplaintProvider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ComplaintProvider()),
        ],
        child: const CCMSApp(),
      ),
    );

    // Verify that the CCMS app title is rendered on splash screen
    expect(find.text(AppConstants.appShortName), findsOneWidget);
    expect(find.text(AppConstants.appName), findsOneWidget);
  });
}
