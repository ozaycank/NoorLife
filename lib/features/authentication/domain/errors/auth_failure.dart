import '../../../../core/errors/failure.dart';

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}
