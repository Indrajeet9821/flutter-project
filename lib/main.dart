// ============================================================
// FILE: lib/main.dart
// PURPOSE: The entry point of the CCMS Flutter application.
//
// This file:
// 1. Initializes the Flutter app
// 2. Sets up Provider for state management
// 3. Applies the custom Material 3 theme from app_theme.dart
// 4. Sets the SplashScreen as the first screen
//
// Later (Phase 9+), Firebase will be initialized here.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'theme/app_theme.dart';
import 'screens/common/splash_screen.dart';

void main() {
  // Ensure Flutter is initialized before doing anything else
  WidgetsFlutterBinding.ensureInitialized();

  // Set the status bar style to match our app's blue theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // Lock the app to portrait mode only (common for phone apps)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    // Run the app after orientation is set
    runApp(const CCMSApp());
  });
}

/// The root widget of the College Complaint Management System.
///
/// This widget wraps the app with Provider for state management,
/// creates a MaterialApp with our custom theme, and sets the
/// SplashScreen as the first screen.
class CCMSApp extends StatelessWidget {
  const CCMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ─── Provider Setup ───
    // ChangeNotifierProvider makes AuthProvider available
    // to ALL widgets in the app. When AuthProvider changes,
    // widgets that listen to it will rebuild automatically.
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        // ─── App Configuration ───
        title: 'CCMS - College Complaint Management System',
        debugShowCheckedModeBanner: false, // Removes the "DEBUG" banner

        // ─── Theme ───
        // Uses our custom Material 3 theme defined in app_theme.dart
        theme: AppTheme.lightTheme,

        // ─── Starting Screen ───
        // The app opens with the Splash Screen, which then
        // navigates to the Login Screen after 3.5 seconds.
        home: const SplashScreen(),
      ),
    );
  }
}
