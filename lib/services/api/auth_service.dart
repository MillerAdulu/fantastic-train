import 'package:demo25/services/api/_base_api_service.dart';
import 'package:logger/logger.dart';

class AuthService extends BaseAPIService<Null> {
  @override
  String get endpoint => '/auth';

  @override
  Null createFromJson(Map<String, dynamic> json) {
    throw UnimplementedError(
      'AuthService does not support single responses yet.',
    );
  }

  @override
  List<Null> createListFromResponse(Map<String, dynamic> response) {
    throw UnimplementedError(
      'AuthService does not support list responses yet.',
    );
  }

  Future<void> register() async {
    final response = await networkUtil.post('/auth/register');

    Logger().f(response);
  }

  Future<void> deleteAccount() async {
    try {
      await networkUtil.delete('$endpoint/delete-account');
    } catch (e) {
      rethrow;
    }
  }
}
