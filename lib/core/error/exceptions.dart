/// Base class for all exceptions in the application.
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when there is a server error.
class ServerException extends AppException {
  ServerException({required String message}) : super(message);
}

/// Exception thrown when there is a cache error.
class CacheException extends AppException {
  CacheException(super.message);
}

/// Exception thrown when there is a network error.
class NetworkException extends AppException {
  NetworkException(super.message);
}
