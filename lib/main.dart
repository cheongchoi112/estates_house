import 'package:estates_house/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'presentation/ui/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/ui/screens/landing_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/my_theme.dart';
import 'presentation/ui/screens/user_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Firebase initialized');
  // Ideal time to initialize
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Connect', // Updated App Title
      theme: myTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const UserDashboard(),
      },
    );
  }
}
