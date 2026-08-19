import 'package:dio/dio.dart';
import '../errors/failure.dart';

class NetworkErrorHandler {
  NetworkErrorHandler._();

  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkFailure('Connection timeout. Please try again.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          return ServerFailure(
            _extractMessage(error.response),
            code: statusCode?.toString(),
          );
        case DioExceptionType.cancel:
          return const NetworkFailure('Request was cancelled.');
        case DioExceptionType.connectionError:
          return const NetworkFailure('No internet connection available.');
        default:
          return const UnexpectedFailure('Unexpected network error occurred.');
      }
    }
    return const UnexpectedFailure('An unknown error occurred.');
  }

  static String _extractMessage(Response<dynamic>? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response?.data as Map<String, dynamic>;
      return data['message']?.toString() ?? 'Server error occurred.';
    }
    return 'Server response error.';
  }
}
