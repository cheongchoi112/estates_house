import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../domain/services/i_user_session_service.dart';
import '../../../../../shared/widgets/form/app_text_field.dart';
import '../../../../../shared/widgets/buttons/app_button.dart';
import '../../../../../shared/widgets/form/error_message.dart';

/// The login page for user authentication.
///
/// This screen depends on `IUserSessionService` for managing user sessions.
/// It handles user login using Firebase Authentication and sets the user data
/// in the session service.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'joe@joe.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '111111');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final IUserSessionService _userSessionService =
      GetIt.instance<IUserSessionService>();

  // Form state
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

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
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found with this email address';
      } else if (e.code == 'wrong-password') {
        message = 'The password you entered is incorrect';
      } else {
        message = 'Authentication failed: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred';
      });
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signup() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

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
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = 'Registration failed: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred';
      });
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.all(0),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Logo and title
                    _buildLogoAndTitle(colorScheme),
                    const SizedBox(height: 40),

                    // Form
                    _buildForm(colorScheme),
                    const SizedBox(height: 24),

                    // Error message
                    if (_errorMessage != null)
                      ErrorMessage(message: _errorMessage!),

                    const SizedBox(height: 16),

                    // Buttons
                    _buildButtons(colorScheme),
                    const SizedBox(height: 30),

                    // Forgot password
                    _buildForgotPassword(colorScheme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle(ColorScheme colorScheme) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Icon(
          Icons.home_work,
          size: 80,
          color: colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Property Connect',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Find your dream property with ease',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _usernameController,
          hintText: 'Enter your email address',
          leadingIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
          leadingIcon: Icons.lock_outline,
          obscureText: !_isPasswordVisible,
          trailingIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _login(),
        ),
      ],
    );
  }

  Widget _buildButtons(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          onPressed: _isLoading ? null : _login,
          label: 'Log In',
          isLoading: _isLoading,
        ),
        const SizedBox(height: 16),
        AppButton(
          onPressed: _isLoading ? null : _signup,
          label: 'Sign Up',
          isSecondary: true,
        ),
      ],
    );
  }

  Widget _buildForgotPassword(ColorScheme colorScheme) {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Forgot password?',
          style: TextStyle(color: colorScheme.primary),
        ),
      ),
    );
  }
}
