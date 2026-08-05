import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/logger_service.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final LoggerService _logger;

  AuthController(this._authRepository, this._logger)
      : super(const AuthState.initial());

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    final (failure, _) = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (failure != null) {
      _logger.warning('SignIn failed: ${failure.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      );
      return false;
    }
    state = state.copyWith(
      isLoading: false,
      isSuccess: true,
    );
    return true;
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    final (failure, _) = await _authRepository.registerWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (failure != null) {
      _logger.warning('Register failed: ${failure.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      );
      return false;
    }
    state = state.copyWith(
      isLoading: false,
      isSuccess: true,
    );
    return true;
  }

  Future<bool> signInGuest() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    final (failure, _) = await _authRepository.signInAnonymously();
    if (failure != null) {
      _logger.warning('Guest sign in failed: ${failure.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      );
      return false;
    }
    state = state.copyWith(
      isLoading: false,
      isSuccess: true,
    );
    return true;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    final (failure, _) = await _authRepository.sendPasswordResetEmail(email);
    if (failure != null) {
      _logger.warning('Send password reset failed: ${failure.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      );
      return false;
    }
    state = state.copyWith(
      isLoading: false,
      isSuccess: true,
    );
    return true;
  }

  Future<bool> resendVerificationEmail() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );
    final (failure, _) = await _authRepository.sendEmailVerification();
    if (failure != null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      );
      return false;
    }
    state = state.copyWith(
      isLoading: false,
      isSuccess: true,
    );
    return true;
  }

  Future<bool> checkEmailVerified() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );
    final (failure, user) = await _authRepository.reloadUser();
    state = state.copyWith(isLoading: false);
    if (failure != null) {
      return false;
    }
    return user?.isEmailVerified ?? false;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
