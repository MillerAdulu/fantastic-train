part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String token;
  const AuthSuccess({required this.token});
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
}
