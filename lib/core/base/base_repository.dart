import '../errors/failure.dart';
import '../network/network_error_handler.dart';

abstract class BaseRepository {
  Future<(Failure?, T?)> guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return (null, result);
    } catch (error) {
      return (NetworkErrorHandler.handle(error), null);
    }
  }
}
