import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'dart:math' as math;

import '../../domain/services/i_user_session_service.dart';

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

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _usernameController =
      TextEditingController(text: 'joe@joe.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '111111');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final IUserSessionService _userSessionService =
      GetIt.instance<IUserSessionService>();

  // Animation controllers
  late final AnimationController _logoAnimationController;
  late final AnimationController _formAnimationController;
  late final AnimationController _buttonAnimationController;

  // Animations
  late final Animation<double> _logoAnimation;
  late final Animation<double> _formAnimation;
  late final Animation<double> _loginButtonAnimation;
  late final Animation<double> _signupButtonAnimation;

  // Form state
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _formAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Setup animations
    _logoAnimation = CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeOut,
    );

    _formAnimation = CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeInOut,
    );

    _loginButtonAnimation = CurvedAnimation(
      parent: _buttonAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );

    _signupButtonAnimation = CurvedAnimation(
      parent: _buttonAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );

    // Start animations sequentially
    _logoAnimationController.forward().then((_) {
      _formAnimationController.forward().then((_) {
        _buttonAnimationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _formAnimationController.dispose();
    _buttonAnimationController.dispose();
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
        color: colorScheme.background,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            // Background design with decorative elements
            _buildBackgroundDecoration(),

            // Main content
            SafeArea(
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
                          _buildErrorMessage(colorScheme),

                        const SizedBox(height: 16),

                        // Buttons
                        _buildButtons(colorScheme),
                        const SizedBox(height: 30),

                        // Additional options
                        _buildAdditionalOptions(colorScheme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle(ColorScheme colorScheme) {
    return ScaleTransition(
      scale: _logoAnimation,
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Building SVG logo programmatically as a placeholder
          SizedBox(
            height: 100,
            width: 100,
            child: Center(
              child: AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: LogoPainter(
                      animation: _logoAnimation.value,
                      primaryColor: colorScheme.primary,
                    ),
                    size: const Size(80, 80),
                  );
                },
              ),
            ),
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
      ),
    );
  }

  Widget _buildForm(ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _formAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_formAnimation),
        child: Column(
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
            _buildTextField(
              controller: _usernameController,
              hintText: 'Enter your email address',
              leadingIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              colorScheme: colorScheme,
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
            _buildTextField(
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
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData leadingIcon,
    bool obscureText = false,
    Widget? trailingIcon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
    ValueChanged<String>? onSubmitted,
    required ColorScheme colorScheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          prefixIcon: Icon(leadingIcon, color: colorScheme.onSurfaceVariant),
          suffixIcon: trailingIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage ?? "",
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScaleTransition(
          scale: _loginButtonAnimation,
          child: _buildButton(
            onPressed: _isLoading ? null : _login,
            label: 'Log In',
            isLoading: _isLoading,
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(height: 16),
        ScaleTransition(
          scale: _signupButtonAnimation,
          child: _buildButton(
            onPressed: _isLoading ? null : _signup,
            label: 'Sign Up',
            isSecondary: true,
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required String label,
    bool isLoading = false,
    bool isSecondary = false,
    required ColorScheme colorScheme,
  }) {
    final backgroundColor =
        isSecondary ? colorScheme.surface : colorScheme.primary;
    final textColor = isSecondary ? colorScheme.primary : colorScheme.onPrimary;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(label),
    );
  }

  Widget _buildAdditionalOptions(ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _buttonAnimationController,
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
              ),
              const SizedBox(width: 16),
              _buildSocialButton(
                icon: Icons.g_mobiledata_rounded,
                color: const Color(0xFFEA4335),
              ),
              const SizedBox(width: 16),
              _buildSocialButton(
                icon: Icons.apple,
                color: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            child: Text(
              'Forgot password?',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required Color color}) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () {},
    );
  }

  Widget _buildBackgroundDecoration() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _logoAnimationController,
        builder: (context, child) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          return CustomPaint(
            painter: BackgroundPainter(
              animation: _logoAnimationController.value,
              colors: [
                colorScheme.primary.withOpacity(0.1),
                colorScheme.primaryContainer.withOpacity(0.1),
                colorScheme.secondary.withOpacity(0.1),
                colorScheme.secondaryContainer.withOpacity(0.1),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for the logo
class LogoPainter extends CustomPainter {
  final double animation;
  final Color primaryColor;

  LogoPainter({required this.animation, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.4 * animation;

    // Draw house icon
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Roof
    final roofPath = Path()
      ..moveTo(centerX, centerY - radius)
      ..lineTo(centerX + radius, centerY)
      ..lineTo(centerX - radius, centerY)
      ..close();

    // House body
    final bodyRect = Rect.fromLTRB(centerX - radius * 0.7, centerY,
        centerX + radius * 0.7, centerY + radius * 0.9);

    // Door
    final doorRect = Rect.fromLTRB(centerX - radius * 0.2,
        centerY + radius * 0.3, centerX + radius * 0.2, centerY + radius * 0.9);

    // Window
    final windowRect = Rect.fromLTRB(centerX - radius * 0.5,
        centerY + radius * 0.2, centerX - radius * 0.1, centerY + radius * 0.5);

    // Animate drawing
    if (animation > 0.3) {
      canvas.drawPath(roofPath, paint);
    }

    if (animation > 0.5) {
      canvas.drawRect(bodyRect, paint);
    }

    if (animation > 0.7) {
      canvas.drawRect(doorRect, Paint()..color = primaryColor.withOpacity(0.7));
      canvas.drawRect(
          windowRect, Paint()..color = primaryColor.withOpacity(0.7));
    }
  }

  @override
  bool shouldRepaint(covariant LogoPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.primaryColor != primaryColor;
  }
}

/// Custom painter for background decoration
class BackgroundPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;

  BackgroundPainter({required this.animation, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    // Create decorative shapes in the background
    final rnd = math.Random(42);

    for (int i = 0; i < 8; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final radius = 20.0 + rnd.nextDouble() * 60;
      final opacity = 0.1 + rnd.nextDouble() * 0.1;
      final color = colors[i % colors.length].withOpacity(opacity * animation);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      if (i % 3 == 0) {
        // Circle
        canvas.drawCircle(Offset(x, y), radius * animation, paint);
      } else if (i % 3 == 1) {
        // Square
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: radius * 1.5 * animation,
            height: radius * 1.5 * animation,
          ),
          paint,
        );
      } else {
        // Triangle
        final path = Path()
          ..moveTo(x, y - radius * animation)
          ..lineTo(x + radius * animation, y + radius * animation)
          ..lineTo(x - radius * animation, y + radius * animation)
          ..close();

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
