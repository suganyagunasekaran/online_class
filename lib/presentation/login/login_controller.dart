
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isAuthenticated,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

final loginControllerProvider =
NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    final normalizedEmail = email.trim();

    if (normalizedEmail.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
            .hasMatch(normalizedEmail)) {
      state = const LoginState(
        errorMessage: 'Enter a valid email address.',
      );
      return false;
    }

    if (password.length < 6) {
      state = const LoginState(
        errorMessage: 'Password must contain at least 6 characters.',
      );
      return false;
    }

    try {
      // Simulates a login request.
      await Future<void>.delayed(const Duration(milliseconds: 500));

      state = const LoginState(isAuthenticated: true);
      return true;
    } catch (_) {
      state = const LoginState(
        errorMessage: 'Login failed. Please try again.',
      );
      return false;
    }
  }
}