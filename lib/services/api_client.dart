import 'package:dio/dio.dart';
import 'package:shuffle_native/constants.dart';
import 'token_storage.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  static Future<void> init() async {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Attach the access token to the request header
        final token = await TokenStorage().getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final isAuthError = error.response?.statusCode == 401;
        final requestOptions = error.requestOptions;

        if (isAuthError) {
          // Try to refresh the access token
          final newToken = await _refreshAccessToken();

          if (newToken != null) {
            requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final clonedRequest = await _dio.fetch(requestOptions);
            return handler.resolve(clonedRequest);
          }
        }

        handler.next(error);
      },
    ));
  }

  static Future<String?> _refreshAccessToken() async {
    final refreshToken = await TokenStorage().getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final response = await _dio.post('/api/token/refresh/', data: {
        'refreshToken': refreshToken,
      });

      final newAccess = response.data['accessToken'];
      final newRefresh = response.data['refreshToken'];

      // Save new tokens
      await TokenStorage().saveTokens(newAccess, newRefresh);

      return newAccess;
    } catch (e) {
      // In case refresh fails, clear tokens
      await TokenStorage().clearTokens();
      return null;
    }
  }

  static Dio get instance => _dio;
}
