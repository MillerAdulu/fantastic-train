import 'dart:convert';

import 'package:demo25/models/remote/auth.dart';
import 'package:demo25/services/api/_base_api_service.dart';

class AuthService extends BaseAPIService<FCUser> {
  @override
  String get endpoint => '/auth';

  @override
  FCUser createFromJson(Map<String, dynamic> json) {
    throw UnimplementedError(
      'AuthService does not support single responses yet.',
    );
  }

  @override
  List<FCUser> createListFromResponse(Map<String, dynamic> response) {
    throw UnimplementedError(
      'AuthService does not support list responses yet.',
    );
  }

  Future<FCUser> register() async {
    final response = await networkUtil.post('/auth/register');

    return FCUser.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<String> signIn({required SignInDTO signInDTO}) async {
    final response = await networkUtil.post(
      '$endpoint/login',
      body: json.encode(signInDTO.toJson()),
    );

    return response['token'] as String;
  }

  Future<FCUser> getUser() async {
    final response = await networkUtil.get(
      '$endpoint/me',
    );

    return FCUser.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> deleteAccount() async {
    await networkUtil.delete('$endpoint/delete-account');
  }
}
