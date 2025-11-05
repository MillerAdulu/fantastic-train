import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
// Generated model files
part 'auth.g.dart'; // Needed for toJson, fromJson

@freezed
abstract class SignInDTO with _$SignInDTO {
  factory SignInDTO({required String email, required String password}) =
      _SignInDTO;

  factory SignInDTO.fromJson(Map<String, dynamic> json) =>
      _$SignInDTOFromJson(json);
}

@freezed
abstract class FCUser with _$FCUser {
  factory FCUser({
    required String ulid,
    required String name,
    required String email,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required String timezone,
    String? password,
    String? token,
  }) = _FCUser;

  factory FCUser.fromJson(Map<String, dynamic> json) => _$FCUserFromJson(json);
}
