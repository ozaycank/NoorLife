import '../errors/failure.dart';

sealed class Result<S, F extends Failure> {
  const Result();
}

class Success<S, F extends Failure> extends Result<S, F> {
  final S value;
  const Success(this.value);
}

class ResultFailure<S, F extends Failure> extends Result<S, F> {
  final F failure;
  const ResultFailure(this.failure);
}
