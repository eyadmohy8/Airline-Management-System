import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Now sync with Node.js backend
      try {
        final String? idToken = await userCredential.user?.getIdToken();
        if (idToken != null) {
          // Send the token to the backend endpoint specifically designed for this
          final url = Uri.parse('http://10.0.2.2:5000/api/auth/login');
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'token': idToken}),
          );

          if (response.statusCode != 200) {
            debugPrint('Backend sync failed: ${response.statusCode} - ${response.body}');
          } else {
            debugPrint('Successfully synced user with Node.js backend!');
          }
        }
      } catch (backendError) {
        debugPrint('Error communicating with backend: $backendError');
        // Do not throw here so the Flutter app still logs the user in visually
      }

      return userCredential;
    } catch (e) {
      debugPrint('Error during Google sign-in: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;
}
