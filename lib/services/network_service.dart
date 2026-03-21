import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// A secure network service that implements SSL Pinning and ensures
/// connections are only made to verified servers.
class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  
  late IOClient client;
  
  // Replace this with the actual SHA-256 base64-encoded hash of your server's certificate.
  // You can obtain this using OpenSSL or by observing the console output in debug mode.
  final List<String> _pinnedHashes = [
    'YOUR_BASE64_SHA256_CERTIFICATE_HASH_HERE', 
  ];

  NetworkService._internal() {
    // 1. Initialize SecurityContext with NO trusted roots.
    // This purposefully causes all certificates to be treated as "bad" initially,
    // forcing them to be evaluated by our badCertificateCallback where we do the SSL Pinning.
    final context = SecurityContext(withTrustedRoots: false);
    
    // Dart's HttpClient negotiates the highest possible TLS version (TLS 1.3) automatically.
    // Since Dart doesn't have a direct `setMinProtocol(TLS1_3)` flag in dart:io,
    // the industry standard approach is configuring the server to ONLY accept TLS 1.3,
    // and relying on Dart's built-in secure negotiation over this context.
    final httpClient = HttpClient(context: context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        
        // 2. Perform SSL Pinning Verification
        // Extract the DER-encoded certificate and hash it using SHA-256
        final derBytes = cert.der;
        final hashBytes = sha256.convert(derBytes).bytes;
        final actualHash = base64Encode(hashBytes);
        
        // 3. Verify Server Identity
        // Return true ONLY if the hash perfectly matches our pinned hashes.
        bool isVerified = _pinnedHashes.contains(actualHash);
        
        if (kDebugMode && !isVerified) {
          debugPrint('⚠️ SSL Pinning Validation Failed for $host!');
          debugPrint('Expected one of: $_pinnedHashes');
          debugPrint('Actual Server Cert Hash: $actualHash');
        }
        
        // If isVerified is false, the connection is instantly rejected with a HandshakeException.
        return isVerified;
      };

    // Wrap the tightly secured HttpClient in an IOClient for standard package:http usage.
    client = IOClient(httpClient);
  }

  // Example secure GET request usage
  Future<dynamic> getSecureData(String endpoint) async {
    try {
      final response = await client.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Secure connection error: $e');
      rethrow;
    }
  }
}
