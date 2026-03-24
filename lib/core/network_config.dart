import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkConfig {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api.example-airline.com';
  
  /// SHA-256 Fingerprints for the target server's certificates.
  static List<String> get allowedFingerprints => [
    dotenv.env['SSL_FINGERPRINT_1'] ?? '',
  ];

  static const int connectionTimeout = 10000; // 10 seconds
  static const int receiveTimeout = 10000;
}
