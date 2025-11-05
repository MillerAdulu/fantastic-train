import 'package:bloc/bloc.dart';
import 'package:demo25/services/api/auth_service.dart';
import 'package:logger/logger.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> register() async {
    emit(const AuthLoading());

    try {
      await AuthService().register();
      // Simulate getting a token from the response
      const token = 'mock_token_12345';
      emit(AuthSuccess(token: token));
      Logger().i('Registration successful. Token: $token');
    } catch (e) {
      emit(AuthError(message: e.toString()));
      Logger().e('Registration failed: $e');
    }
  }

  void reset() {
    emit(const AuthInitial());
  }
}