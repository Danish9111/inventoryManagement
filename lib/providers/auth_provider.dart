import 'package:dream_pos/providers/auth_provider.dart' as _authService;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthService _authService;

  @override
  Future<User?> build() async {
    // Initialize AuthService
    _authService = ref.read(authServiceProvider);

    // Check if user is already logged in
    final token = await _authService.getToken();
    if (token != null && token.isNotEmpty) {
      return User(id: '', name: '', email: '', token: token);
    }

    // No logged in user
    return null;
  }

  Future<void> login(String email, String password) async {
    // async state handling built-in
    state = const AsyncLoading();
    try {
      final user = await _authService.login(email, password);
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(
        e.toString().replaceAll('Exception: ', ''),
        StackTrace.current,
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await _authService.register(name, email, password);
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(
        e.toString().replaceAll('Exception: ', ''),
        StackTrace.current,
      );
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncData(null);
  }
}

// Modern AsyncNotifier for auth
final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  () => AuthNotifier(),
);
