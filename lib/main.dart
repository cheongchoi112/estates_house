import 'package:estates_house/core/dependency_injection/setup_locator.dart';
import 'package:estates_house/firebase_options.dart';
import 'package:estates_house/presentation/ui/themes/my_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'presentation/ui/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/ui/screens/landing_page.dart';
import 'presentation/ui/screens/user_dashboard.dart';

/// The project follows the principles of Clean Architecture, which ensures a modular, testable, and maintainable codebase.
/// Here's a brief overview of each layer:
///
/// **Presentation Layer**:
/// - **Purpose**: Contains the UI components and screens of the application.
/// - **Files**:
///   - `LandingPage`: The main landing page where users can search for properties.
///   - `LoginPage`: The login page for user authentication.
///   - `UserDashboard`: The user dashboard for managing properties.
///   - **Widgets**: Reusable UI components like `PropertyList` and `PropertyCard`.
///
/// **Domain Layer**:
/// - **Purpose**: Contains the core business logic and entities.
/// - **Files**:
///   - **Entities**: Data models like `Property`.
///   - **Services**: Interfaces for business operations, e.g., `IPropertyService` and `IUserSessionService`.
///
/// **Data Layer**:
/// - **Purpose**: Handles data access and service implementations.
/// - **Files**:
///   - **Services**: Concrete implementations of domain service interfaces, e.g., `PropertyService` and `UserSessionService`.
///
/// **Core Layer**:
/// - **Purpose**: Contains core utilities and configurations.
/// - **Files**:
///   - **Network**: Network-related utilities like `FirebaseApiClient`.
///   - **Dependency Injection**: Setup for dependency injection using `GetIt`, e.g., `setup_locator`.

/// Main entry point of the application.
///
/// This function initializes Firebase, sets up dependency injection, and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    // Ideal time to initialize
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Connect', // Updated App Title
      theme: getMaterial3Theme(),
      darkTheme: getMaterial3DarkTheme(),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const UserDashboard(),
      },
    );
  }
}
