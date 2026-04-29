import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

final apiServiceProvider = Provider((ref) {
  return ApiService();
});

final authServiceProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthService(apiService: apiService);
});

final authStateProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService: authService);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthController({required this.authService}) : super(const AuthState.loading()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final isLoggedIn = await authService.isLoggedIn();
    if (isLoggedIn) {
      try {
        final user = await authService.getCurrentUser();
        state = AuthState.authenticated(user: user['user']);
      } catch (e) {
        state = const AuthState.unauthenticated();
      }
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthState.loading();
    try {
      await authService.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      final user = await authService.getCurrentUser();
      state = AuthState.authenticated(user: user['user']);
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      await authService.login(email: email, password: password);
      final user = await authService.getCurrentUser();
      state = AuthState.authenticated(user: user['user']);
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  Future<void> logout() async {
    await authService.logout();
    state = const AuthState.unauthenticated();
  }
}

sealed class AuthState {
  const AuthState();

  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({required Map<String, dynamic> user}) = _Authenticated;
  const factory AuthState.error({required String message}) = _Error;

  T when<T>({
    required T Function() onUnauthenticated,
    required T Function() onLoading,
    required T Function(Map<String, dynamic> user) onAuthenticated,
    required T Function(String message) onError,
  }) {
    return switch (this) {
      _Unauthenticated() => onUnauthenticated(),
      _Loading() => onLoading(),
      _Authenticated(:final user) => onAuthenticated(user),
      _Error(:final message) => onError(message),
    };
  }

  bool get isAuthenticated => this is _Authenticated;
}

class _Unauthenticated extends AuthState {
  const _Unauthenticated();
}

class _Loading extends AuthState {
  const _Loading();
}

class _Authenticated extends AuthState {
  final Map<String, dynamic> user;
  const _Authenticated({required this.user});
}

class _Error extends AuthState {
  final String message;
  const _Error({required this.message});
}
