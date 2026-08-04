abstract class BaseException implements Exception {
  final String message;
  final int? statusCode;

  const BaseException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'BaseException(message: $message, statusCode: $statusCode)';
}

class NetworkException extends BaseException {
  const NetworkException({required super.message, super.statusCode});
}

class ServerException extends BaseException {
  const ServerException({required super.message, super.statusCode});
}

class CacheException extends BaseException {
  const CacheException({required super.message});
}