import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:kosan_kan/data/local/auth_local.dart';
import 'package:kosan_kan/app/notifications.dart';

class ApiClient {
  final Dio dio;
  final AuthLocal authLocal;
  bool? _apiAvailable;
  Future<bool>? _apiAvailableFuture;
  // Refresh token coordination
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  ApiClient(this.dio, this.authLocal) {
    // add Talker + Dio logger for richer HTTP logging with colored output
    final talker = Talker();
    // human-friendly colored pens
    final requestPen = AnsiPen()..blue();
    final responsePen = AnsiPen()..green();
    final errorPen = AnsiPen()..red();

    final settings = TalkerDioLoggerSettings(
      requestPen: requestPen,
      responsePen: responsePen,
      errorPen: errorPen,
      // show response headers and response bodies in console
      printResponseData: true,
      printResponseHeaders: true,
      // also show request headers/data so logs are complete
      printRequestData: true,
      printRequestHeaders: true,
    );

    dio.interceptors.add(TalkerDioLogger(talker: talker, settings: settings));
    // start background API availability check once on client creation
    // this runs without awaiting so app startup isn't blocked
    checkApiAvailable();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final tokens = await authLocal.getAuthToken();
          final accessToken = tokens['accessToken'];
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // If we can't reach the server (socket exception / connection refused)
          // or if server returns a 5xx, mark the API as unavailable so the UI
          // can show the server error page.
          try {
            final isSocket = error.error is SocketException;
            final isConnectionError =
                error.type == DioExceptionType.connectionError;
            final message = error.message?.toLowerCase() ?? '';
            final containsConnectionRefused =
                message.contains('connection refused') ||
                message.contains('connection error');

            if (isSocket || isConnectionError || containsConnectionRefused) {
              apiAvailable.value = false;
            } else if ((error.response?.statusCode ?? 0) >= 500) {
              apiAvailable.value = false;
            }
          } catch (_) {}

          if (error.response?.statusCode == 401) {
            try {
              // Avoid trying to refresh when the failed request is the
              // refresh endpoint itself to prevent recursion.
              final req = error.requestOptions;
              final path = req.path;
              if (path.contains('refresh')) {
                return handler.next(error);
              }

              final tokens = await authLocal.getAuthToken();
              final refreshToken = tokens['refreshToken'];
              if (refreshToken == null) {
                return handler.next(error);
              }

              // Perform refresh (serialized so only one refresh runs at a time)
              final refreshed = await _refreshTokens(refreshToken);
              if (!refreshed) return handler.next(error);

              // Read newest access token and retry the original request
              final newTokens = await authLocal.getAuthToken();
              final newAccess = newTokens['accessToken'];
              if (newAccess == null) return handler.next(error);

              // mark as retry to avoid infinite loops
              req.headers['Authorization'] = 'Bearer $newAccess';
              req.extra['retry'] = true;

              final clonedResponse = await dio.fetch(req);
              return handler.resolve(clonedResponse);
            } catch (_) {
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );
    dio.interceptors.add(LogInterceptor());
    dio.options.validateStatus = (status) {
      return status != null && status >= 200 && status < 500;
    };
  }

  /// Checks API availability once and caches the result.
  /// Subsequent calls return the cached value. To force a re-check, pass
  /// `force: true`.
  Future<bool> checkApiAvailable({bool force = false}) {
    if (!force && _apiAvailable != null) return Future.value(_apiAvailable);
    if (!force && _apiAvailableFuture != null) return _apiAvailableFuture!;

    _apiAvailableFuture = () async {
      try {
        final response = await dio.get('health/');
        final code = response.statusCode ?? 0;
        _apiAvailable = code >= 200 && code < 300;
      } catch (_) {
        _apiAvailable = false;
      } finally {
        // clear the future so subsequent forced checks can recreate it
        _apiAvailableFuture = null;
        // update global notifier so UI can react to API availability
        try {
          apiAvailable.value = _apiAvailable ?? false;
        } catch (_) {}
      }
      return _apiAvailable ?? false;
    }();

    return _apiAvailableFuture!;
  }

  /// Convenience getter
  Future<bool> isApiAvailable() => checkApiAvailable();

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<bool> _refreshTokens(String refreshToken) async {
    if (_isRefreshing) {
      // wait for ongoing refresh
      try {
        await _refreshCompleter?.future;
        final tokens = await authLocal.getAuthToken();
        return tokens['accessToken'] != null;
      } catch (_) {
        return false;
      }
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();
    try {
      // Use a fresh Dio instance without interceptors to avoid recursion
      final refreshDio = Dio(dio.options);
      final response = await refreshDio.post(
        'api/auth/refresh/',
        data: {'refresh': refreshToken},
      );
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final access = response.data['access_token'] as String?;
        final refresh = response.data['refresh_token'] as String?;
        if (access != null && refresh != null) {
          await authLocal.saveAuthToken(access, refresh);
          _refreshCompleter?.complete();
          _isRefreshing = false;
          _refreshCompleter = null;
          return true;
        }
      }
      _refreshCompleter?.complete();
      _isRefreshing = false;
      _refreshCompleter = null;
      return false;
    } catch (_) {
      try {
        _refreshCompleter?.complete();
      } catch (_) {}
      _isRefreshing = false;
      _refreshCompleter = null;
      return false;
    }
  }
}
