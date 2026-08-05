import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/providers/base_providers.dart';
import '../domain/entities/auth_user.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});

final authStateChangesProvider = StreamProvider<AuthUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
}); 

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final logger = ref.watch(loggerProvider);
  return AuthController(repository, logger);
});
