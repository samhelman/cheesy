import 'dart:async';
import 'package:authentication_repository/src/models/user.dart';
import 'package:authentication_repository/src/services/authentication_status_service.dart';

/// Generic repository class for authentication
/// Extend it and add your own implementation to authenticate
abstract class AuthenticationRepository with AuthenticationStatusService {

  Future<void> logInWithCredentials({
    required String username,
    required String password,
  });

  /// If the app stores credentials,
  /// you could use this method to validate the credentials
  Future<void> tryAuthenticate();

  Future<User> getUser();

  /// call super.logout when overriding this
  Future<void> logOut() async => controller.add(AuthenticationStatus.unauthenticated);
}
