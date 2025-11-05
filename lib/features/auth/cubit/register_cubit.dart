import 'package:bloc/bloc.dart';
import 'package:demo25/models/remote/auth.dart';
import 'package:demo25/services/api/auth_service.dart';
import 'package:demo25/services/local_storage/hive/hive_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.dart';
part 'register_cubit.freezed.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required AuthService authService,
    required HiveService hiveService,
  }) : super(const RegisterState.initial()) {
    _authService = authService;
    _hiveService = hiveService;
  }

  late AuthService _authService;
  late HiveService _hiveService;

  Future<void> register() async {
    emit(const RegisterState.loading());
    try {
      final user = await _authService.register();

      _hiveService.auth
        ..persistToken(user.token!)
        ..persistProfile(user)
        ..persistCredentials(email: user.email);

      emit(RegisterState.loaded(user: user));
    } catch (e) {
      emit(RegisterState.error(e.toString()));
    }
  }
}
