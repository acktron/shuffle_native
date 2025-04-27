import 'package:dio/dio.dart';
import 'package:logger/logger.dart'; // Add logger package
import 'package:shuffle_native/utils/constants.dart';
import 'token_storage.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(seconds: 5), // 5 seconds timeout for connection
    receiveTimeout: Duration(seconds: 5), // 5 seconds timeout for receiving data
  ));

  static final Logger _logger = Logger(); // Initialize logger

  static bool _isRefreshing = false;
  static final List<void Function(String)> _queuedRequests = [];

  static Future<void> init() async {
    _dio.options.validateStatus = (status) => true;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage().getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final isAuthError = error.response?.statusCode == 401;
          final requestOptions = error.requestOptions;

          if (isAuthError && requestOptions.extra['retried'] != true) {
            requestOptions.extra['retried'] = true;

            if (_isRefreshing) {
              _queuedRequests.add((String token) {
                requestOptions.headers['Authorization'] = 'Bearer $token';
                _dio.fetch(requestOptions).then(
                  (r) => handler.resolve(r),
                  onError: (e) => handler.reject(e),
                );
              });
              return;
            }

            _isRefreshing = true;
            final newToken = await _refreshAccessToken();
            _isRefreshing = false;

            if (newToken != null) {
              requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final clonedResponse = await _dio.fetch(requestOptions);
              handler.resolve(clonedResponse);

              for (final callback in _queuedRequests) {
                callback(newToken);
              }
              _queuedRequests.clear();
              return;
            } else {
              await TokenStorage().clearTokens();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  static Future<String?> _refreshAccessToken() async {
    final refreshToken = await TokenStorage().getRefreshToken();
    if (refreshToken == null) {
      _logger.w('No refresh token available');
      return null;
    }

    try {
      final response = await _dio.post(
        '/api/token/refresh/',
        data: {'refresh': refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final newAccess = response.data['access'];
      final newRefresh = response.data['refresh'];

      await TokenStorage().saveTokens(newAccess, newRefresh);
      _logger.i('Token refreshed successfully');
      return newAccess;
    } catch (e) {
      _logger.e('Token refresh failed', error: e);
      await TokenStorage().clearTokens();
      return null;
    }
  }

  static Dio get instance => _dio;
}
