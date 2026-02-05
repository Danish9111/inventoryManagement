import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthInitial()) {
    checkLoginStatus();
  }

  Future<void> login(String email, String password) async {
    try {
      state = AuthLoading();
      final user = await _authService.login(email, password);
      state = AuthSuccess(user);
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      state = AuthLoading();
      final user = await _authService.register(name, email, password);
      state = AuthSuccess(user);
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthInitial();
  }

  Future<void> checkLoginStatus() async {
    final token = await _authService.getToken();
    if (token != null && token.isNotEmpty) {
      // In a real app, you might want to fetch the user profile here using the token
      // For now, we will just assume valid session if token exists, or stay in Initial/Success with dummy user if needed,
      // But ideally we need a 'getUserProfile' endpoint.
      // putting state as Initial for now, logic to be refined.
      // If we don't have user data, we can't really go to Success unless we fetch it.
      // PROVISIONAL: We won't auto-login to Success state without fetching user data.
      // So implementation often needs a /me endpoint.
    }
  }
}
