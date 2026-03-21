import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003366),
              Color(0xFF001F3F),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                const Icon(
                  Icons.flight_takeoff,
                  color: Color(0xFFD4AF37),
                  size: 80,
                ),
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
                const Spacer(flex: 3),
                _buildSocialButton(
                  context,
                  icon: FontAwesomeIcons.google,
                  label: 'Continue with Google',
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () {
                    context.go('/search');
                  },
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  context,
                  icon: FontAwesomeIcons.apple,
                  label: 'Continue with Apple',
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    context.go('/search');
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: textColor),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
