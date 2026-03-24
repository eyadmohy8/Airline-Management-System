import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  // Singleton instance
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Keys
  static const String _keyUserId = 'user_id';
  static const String _keyIdToken = 'id_token';

  /// Saves the user session data securely.
  Future<void> saveUserSession({required String userId, String? idToken}) async {
    await _storage.write(key: _keyUserId, value: userId);
    if (idToken != null) {
      await _storage.write(key: _keyIdToken, value: idToken);
    }
  }

  /// Retrieves the stored user ID.
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Retrieves the stored ID token.
  Future<String?> getIdToken() async {
    return await _storage.read(key: _keyIdToken);
  }

  /// Clears all stored session data.
  Future<void> clearSession() async {
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyIdToken);
  }

  /// Checks if a session exists.
  Future<bool> hasSession() async {
    final userId = await getUserId();
    return userId != null;
  }
}
