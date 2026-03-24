import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/security_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(); // Keep if needed for other things, but usually not
  // Removed _passwordController

  bool _isLoading = false;

  // Removed _login method

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      
      // For Google Sign-In 7.2.0, we need to explicitly authorize scopes to get the access token
      final GoogleSignInClientAuthorization authz = await googleUser.authorizationClient.authorizeScopes([
        'email',
        'profile',
        'openid',
      ]);

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authz.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        await SecurityService().saveUserSession(
          userId: user.uid,
          idToken: googleAuth.idToken,
        );
      }
      if (mounted) context.go('/search');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Google Sign-In failed')),
        );
      }
    } catch (e) {
      if (mounted) {
        if (!e.toString().toLowerCase().contains('cancel')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred: $e')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF003366), Color(0xFF001F3F)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const SizedBox(height: 60),
                   const Icon(Icons.flight_takeoff, color: Color(0xFFD4AF37), size: 80),
                   const SizedBox(height: 32),
                   Text(
                    'Welcome to\nAeroLine',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                   const SizedBox(height: 16),
                   Text(
                    'Premium Flight Experience',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                   const SizedBox(height: 48),
                  
                  if (_isLoading)
                     const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
                  else ...[
                    // Removed Email & Password fields and Login button
                     const SizedBox(height: 24),
                    
                    _buildSocialButton(
                      context,
                      icon: FontAwesomeIcons.google,
                      label: 'Continue with Google',
                      backgroundColor: Colors.white,
                      textColor: Colors.black87,
                      onPressed: _signInWithGoogle,
                    ),
                     const SizedBox(height: 16),
                    _buildSocialButton(
                      context,
                      icon: FontAwesomeIcons.apple,
                      label: 'Continue with Apple',
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      onPressed: () => context.go('/search'),
                    ),
                  ],
                   const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSocialButton(BuildContext context, {required IconData icon, required String label, required Color backgroundColor, required Color textColor, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: textColor),
           const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
