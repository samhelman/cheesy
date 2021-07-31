import 'package:authentication_repository/src/models/user.dart';
import 'package:authentication_repository/src/repositories/authentication_repository.dart';
import 'package:authentication_repository/src/services/authentication_status_service.dart';
import 'package:authentication_repository/src/django_authentication_response.dart';
import 'package:local_storage_service/local_storage_service.dart';
import 'package:network_client/network_client.dart';

/// Implementation of authentication using our Django base api
class DjangoApiAuthenticationRepository extends AuthenticationRepository
    with LocalStorageMixin {
  static const _TOKEN_KEY = 'auth_token_key';
  static const _USER_ID = 'user_id_key';

  final String loginPath;
  final NetworkClient client;

  DjangoApiAuthenticationRepository({
    required this.client,
    required this.loginPath,
  });

  Future<String> get token async => await readSecureValue(_TOKEN_KEY);

  @override
  Future<void> logInWithCredentials({
    required String username,
    required String password,
  }) async {
    final body = {"username": username, "password": password};
    try {
      final response = await client.post(loginPath, body: body);
      final DjangoAuthenticationResponse djangoAuthenticationResponse =
          DjangoAuthenticationResponse.fromJson(response['user']);
      await storeSecureValue(_TOKEN_KEY, djangoAuthenticationResponse.token);
      await storeSecureValue(_USER_ID, djangoAuthenticationResponse.id.toString());
      controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    client.removeHeaders();
    await deleteSecureValue(_TOKEN_KEY);
    await deleteSecureValue(_USER_ID);
    super.logOut();
  }

  @override
  Future<void> tryAuthenticate() async {
    try {
      await readSecureValue(_TOKEN_KEY);
      controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  @override
  Future<User> getUser() async {
    try {
      final id = await readSecureValue(_USER_ID);
      return User(id);
    } catch (e) {
      rethrow;
    }
  }
}
