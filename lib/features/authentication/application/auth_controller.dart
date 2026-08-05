import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/logging/logger_service.dart';
import '../../../../core/providers/base_providers.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_providers.dart';
import 'auth_state.dart';

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _authRepository;
  late final LoggerService _logger;
  late final SecureStorageService _secureStorage;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _logger = ref.watch(loggerProvider);
    _secureStorage = getIt<SecureStorageService>();
    return const AuthState.initial();
  }

  Future<bool> signIn({
    required String email,
    required String password,
    required bool rememberMe,
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
      NotificationService.showError(failure.message);
      state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      );
      return false;
    }

    await _secureStorage.saveRememberMe(
      rememberMe: rememberMe,
      email: email,
    );

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
      NotificationService.showError(failure.message);
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
      NotificationService.showError(failure.message);
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
      NotificationService.showError(failure.message);
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
      NotificationService.showError(failure.message);
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
      NotificationService.showError(failure.message);
      return false;
    }
    return user?.isEmailVerified ?? false;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
