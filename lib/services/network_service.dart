import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import '../core/network_config.dart';

class NetworkService {
  late Dio _dio;

  // Singleton instance
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  NetworkService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: NetworkConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: NetworkConfig.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: NetworkConfig.receiveTimeout),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
           return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );

    // Add SSL Pinning Interceptor
    _dio.interceptors.add(SSLPinningInterceptor());
  }

  Dio get client => _dio;

  /// Performs a secure GET request with SSL Pinning.
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  /// Performs a secure POST request with SSL Pinning.
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}

/// Interceptor that performs SSL Pinning check before every request.
class SSLPinningInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final url = options.uri.toString();
    
    // Skip pinning for non-HTTPS
    if (!url.startsWith('https://')) {
      return handler.next(options);
    }

    try {
      // http_certificate_pinning check
      final String result = await HttpCertificatePinning.check(
        serverURL: url,
        headerHttp: options.headers.map((key, value) => MapEntry(key, value.toString())),
        allowedSHAFingerprints: NetworkConfig.allowedFingerprints,
        sha: SHA.SHA256,
        timeout: 10,
      );

      if (result == 'CONNECTION_SECURE') {
        return handler.next(options);
      } else {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'SSL Pinning Verification Failed: Connection is not secure.',
          ),
        );
      }
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'SSL Pinning Error: $e',
        ),
      );
    }
  }
}
