import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';

import '../../common/index.dart';

/// Network client for making API requests with caching support
class NetworkClient {
  late final Dio _dio;
  late final CacheStore _cacheStore;
  bool _isInitialized = false;

  /// Initialize the network client
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Use memory cache for simplicity
    _cacheStore = MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add cache interceptor
    _dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: _cacheStore,
          policy: CachePolicy.forceCache,
          hitCacheOnErrorCodes: [401, 403, 404, 500, 502, 503, 504],
          maxStale: const Duration(hours: 24),
          priority: CachePriority.normal,
        ),
      ),
    );

    // Add logging interceptor in debug mode only
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint('🌐 $obj'),
        ),
      );
    }

    _isInitialized = true;
  }

  /// Make a GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to meaningful exceptions
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        if (statusCode == 404) {
          return NetworkException('Resource not found.');
        } else if (statusCode >= 500) {
          return NetworkException('Server error. Please try again later.');
        }
        return NetworkException('Request failed with status $statusCode');
      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please check your network.',
        );
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled.');
      default:
        return NetworkException('An unexpected error occurred.');
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _cacheStore.clean();
  }
}

/// Custom exception for network errors
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}
