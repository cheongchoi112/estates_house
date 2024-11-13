import 'package:estates_house/domain/services/i_user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

/// The login page for user authentication.
///
/// This screen depends on `IUserSessionService` for managing user sessions.
/// It handles user login using Firebase Authentication and sets the user data
/// in the session service.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'joe@joe.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '111111');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final IUserSessionService _userSessionService =
      GetIt.instance<IUserSessionService>();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      debugPrint('Successfully logged in: ${userCredential.user?.email}');
      userCredential.user?.getIdToken().then((value) {
        if (value != null) {
          _userSessionService.setUserData(
              value, userCredential.user?.email ?? '');
          Navigator.pushReplacementNamed(context, '/dashboard');
          debugPrint('Token: $value');
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _signup() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        _userSessionService.setUserData(
            token, userCredential.user?.email ?? '');
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Property Connect',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signup,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
