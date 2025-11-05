import 'package:bloc/bloc.dart';
import 'package:demo25/models/remote/auth.dart';
import 'package:demo25/models/remote/failure.dart';
import 'package:demo25/services/api/auth_service.dart';
import 'package:demo25/services/local_storage/hive/hive_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.dart';
part 'sign_in_cubit.freezed.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({
    required AuthService authService,
    required HiveService hiveService,
  }) : super(const SignInState.initial()) {
    _authService = authService;
    _hiveService = hiveService;
  }
  late HiveService _hiveService;
  late AuthService _authService;

  Future<void> signIn({required String code}) async {
    emit(const SignInState.loading());
    try {
      // Clear any previous local state
      _hiveService.clearPrefs();

      final token = await _authService.signIn(
        signInDTO: SignInDTO(
          email: '$code@fluttercondev.ke',
          password: code,
        ),
      );

      _hiveService.auth.persistToken(token);

      final user = await _authService.getUser();

      _hiveService.auth.persistProfile(user);

      emit(const SignInState.loaded());
    } on Failure catch (e) {
      emit(SignInState.error(e.message));
    } catch (e) {
      emit(const SignInState.error('An unknown error occurred'));
    }
  }
}
